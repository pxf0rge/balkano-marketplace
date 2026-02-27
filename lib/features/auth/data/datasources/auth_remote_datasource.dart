import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDatasource {
  final SupabaseClient client;

  AuthRemoteDatasource(this.client);

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String location,
  }) async {
    final res = await client.functions.invoke(
      'signup',
      body: {
        'email': email,
        'password': password,
        'name': fullName,
        'phone': phone,
        'location': location,
      },
    );

    // اگر هیچ دیتایی نیومده
    if (res.data == null) {
      throw Exception("signup_failed".tr());
    }

    // اگر String بود
    if (res.data is String) {
      final text = res.data.toString();

      // موفق
      if (text.contains('success')) {
        await Supabase.instance.client.auth.signInWithPassword(
          email: email,
          password: password,
        );

        return;
      }

      // خطا
      throw Exception(text);
    }

    // اگر Map بود
    final data = res.data as Map<String, dynamic>;

    if (data['success'] == true) {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return;
    }

    if (data['error'] != null) {
      throw Exception(data['error']);
    }

    throw Exception("signup_failed".tr());
  }
}
