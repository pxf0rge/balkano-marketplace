import 'package:Balkano/core/helpers/auth_helper.dart';
import 'package:Balkano/core/layout/main_layout.dart';
import 'package:Balkano/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:Balkano/features/auth/data/repository/auth_repository_impl.dart';
import 'package:Balkano/features/auth/domain/signup_usecase.dart';
import 'package:Balkano/features/auth/presentation/pages/login_page.dart';
import 'package:Balkano/features/auth/presentation/widgets/full_name_field.dart';
import 'package:Balkano/features/auth/presentation/widgets/location_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/email_field.dart';
import '../widgets/mobile_field.dart';
import '../widgets/password_field.dart';
import '../widgets/confirm_password_field.dart';
import '../widgets/auth_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _locationController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final supabase = Supabase.instance.client;

        final datasource = AuthRemoteDatasource(supabase);
        final repository = AuthRepositoryImpl(datasource);
        final signupUseCase = SignupUseCase(repository);

        await signupUseCase(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          fullName: _fullNameController.text.trim(),
          phone: _mobileController.text.trim(),
          location: _locationController.text.trim(),
        );
        await AuthHelper.loadCurrentUser();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
          (route) => false,
        );
      } catch (e) {
        await Supabase.instance.client.auth.signOut();
        String message = "signup_failed".tr();

        ("Signup error: $e");

        if (e.toString().contains('EMAIL_ALREADY_EXISTS')) {
          message = "email_already_registered".tr();
        } else if (e.toString().contains('PHONE_ALREADY_EXISTS')) {
          message = "phone_already_registered".tr();
        } else if (e.toString().contains('user_already_exists')) {
          message = "user_already_exists".tr();
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),

                          Text(
                            "sign_up".tr(),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "signup_subtitle".tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 48),

                          FullNameField(controller: _fullNameController),
                          const SizedBox(height: 32),

                          LocationField(controller: _locationController),
                          const SizedBox(height: 32),

                          EmailField(controller: _emailController),
                          const SizedBox(height: 32),

                          MobileField(controller: _mobileController),
                          const SizedBox(height: 32),

                          PasswordField(
                            passwordController: _passwordController,
                          ),
                          const SizedBox(height: 32),

                          ConfirmPasswordField(
                            passwordController: _passwordController,
                          ),
                          const SizedBox(height: 48),

                          const Spacer(),

                          AuthButton(
                            text: "sign_up".tr(),
                            onPressed: _isLoading ? null : _submit,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text("sign_up".tr()),
                          ),

                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "already_member".tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                child: Text(
                                  "login".tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
