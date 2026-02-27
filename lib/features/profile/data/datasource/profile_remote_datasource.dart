import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../../../../data/models/user.dart';
import 'package:path_provider/path_provider.dart';

class ProfileRemoteDatasource {
  final SupabaseClient client;

  ProfileRemoteDatasource(this.client);

  Future<User> getCurrentUserProfile() async {
    final uid = client.auth.currentUser!.id;

    final data = await client.from('users').select().eq('id', uid).single();

    return User.fromJson(data);
  }

  Future<bool> isEmailTaken(String email, String myId) async {
    final data = await client
        .from('users')
        .select('id')
        .eq('email', email)
        .neq('id', myId)
        .maybeSingle();

    return data != null;
  }

  Future<bool> isPhoneTaken(String phone, String myId) async {
    final data = await client
        .from('users')
        .select('id')
        .eq('phone', phone)
        .neq('id', myId)
        .maybeSingle();

    return data != null;
  }

  Future<File> _compressAvatar(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 45,
      format: CompressFormat.jpeg,
    );

    if (result == null) return file;

    return File(result.path);
  }

  Future<String?> uploadAvatar(File file) async {
    final uid = client.auth.currentUser!.id;
    final fileName = '$uid/avatar.jpg';

    final compressedFile = await _compressAvatar(file);

    await client.storage
        .from('avatars')
        .upload(
          fileName,
          compressedFile,
          fileOptions: const FileOptions(upsert: true),
        );

    final baseUrl = client.storage.from('avatars').getPublicUrl(fileName);

    // 👇 مهم
    return "$baseUrl?t=${DateTime.now().millisecondsSinceEpoch}";
  }

  Future<void> updateProfile({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String location,
    String? avatarUrl,
  }) async {
    // Update auth email
    final currentEmail = client.auth.currentUser!.email;

    if (email != currentEmail) {
      await client.auth.updateUser(UserAttributes(email: email));
    }

    await client
        .from('users')
        .update({
          'name': name,
          'email': email,
          'phone': phone,
          'location': location,
          'profile_image': ?avatarUrl,
        })
        .eq('id', id);
  }
}
