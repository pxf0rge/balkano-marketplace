import 'dart:io';

import 'package:Balkano/data/models/user.dart';
import 'package:Balkano/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../widgets/profile_avatar.dart';
import '../widgets/profile_info_tile.dart';
import '../widgets/profile_action_buttons.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _isSaving = false;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  late User userLocal;

  @override
  void initState() {
    super.initState();
    userLocal = widget.user.copy(); // clone
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "edit_profile".tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 60),

            ProfileAvatar(
              imageFile: selectedImage,
              onTap: _pickImage,
              user: userLocal,
            ),

            const SizedBox(height: 48),

            ProfileInfoTile(
              label: "full_name".tr(),
              value: userLocal.name,
              icon: Icons.edit,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "name_empty".tr();
                }
                if (v.length < 3) {
                  return "name_min_length".tr();
                }
                return null;
              },
              onChanged: (v) => setState(() => userLocal.name = v),
            ),

            const SizedBox(height: 16),

            ProfileInfoTile(
              label: "Email",
              value: userLocal.email,
              icon: Icons.edit,
              validator: (v) {
                if (v == null || v.isEmpty) return "email_required".tr();

                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                if (!emailRegex.hasMatch(v)) {
                  return "valid_email".tr();
                }
                return null;
              },
              onChanged: (v) => setState(() => userLocal.email = v),
            ),

            const SizedBox(height: 16),

            ProfileInfoTile(
              label: "phone".tr(),
              value: userLocal.phone,
              icon: Icons.edit,
              validator: (v) {
                if (v == null || v.isEmpty) return "phone_required".tr();
                if (!RegExp(r'^[0-9]{10,15}$').hasMatch(v)) {
                  return "valid_phone".tr();
                }
                return null;
              },
              onChanged: (v) => setState(() => userLocal.phone = v),
            ),

            const SizedBox(height: 16),

            ProfileInfoTile(
              label: "location".tr(),
              value: userLocal.location,
              icon: Icons.edit,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "Location cannot be empty";
                }
                return null;
              },
              onChanged: (v) => setState(() => userLocal.location = v),
            ),

            const SizedBox(height: 42),
            ProfileActionButtons(
              isLoading: _isSaving,
              user: userLocal,
              onSave: () async {
                setState(() => _isSaving = true);

                try {
                  final datasource = ProfileRemoteDatasource(
                    Supabase.instance.client,
                  );

                  // Check duplicates
                  if (await datasource.isEmailTaken(
                    userLocal.email,
                    userLocal.id,
                  )) {
                    throw Exception("email_exists".tr());
                  }

                  if (await datasource.isPhoneTaken(
                    userLocal.phone,
                    userLocal.id,
                  )) {
                    throw Exception("phone_exists".tr());
                  }

                  String? avatarUrl;

                  if (selectedImage != null) {
                    avatarUrl = await datasource.uploadAvatar(selectedImage!);
                    userLocal.profileImageUrl = avatarUrl;
                  }

                  await datasource.updateProfile(
                    id: userLocal.id,
                    name: userLocal.name,
                    email: userLocal.email,
                    phone: userLocal.phone,
                    location: userLocal.location,
                    avatarUrl: avatarUrl,
                  );

                  if (!mounted) return;

                  Navigator.pop(context, userLocal);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                } finally {
                  if (mounted) setState(() => _isSaving = false);
                }
              },

              onDiscard: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 115),
          ],
        ),
      ),
    );
  }
}
