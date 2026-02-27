import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/core/constants/global_values.dart';
import 'package:Balkano/core/layout/main_layout.dart';
import 'package:Balkano/features/onboarding/presentation/pages/lets_try_screen.dart';
import 'package:Balkano/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:Balkano/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:Balkano/features/profile/domain/usecases/get_current_user_usecase.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startProcess();
    });
  }

  Future<void> _startProcess() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 🔹 simple ping to supabase
      await Supabase.instance.client.from('users').select('id').limit(1);

      await _checkSession();
    } catch (e) {
      ('Error connecting to Supabase: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = "cannot_connect_server".tr();
      });
    }
  }

  Future<void> _checkSession() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      final datasource = ProfileRemoteDatasource(Supabase.instance.client);
      final repo = ProfileRepositoryImpl(datasource);
      final usecase = GetCurrentUserUseCase(repo);

      final user = await usecase();
      GlobalValues.currentUser = user;
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            session != null ? const MainLayout() : const LetsTryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Center(
            child: _isLoading
                ? Center(
                    child: Image.asset(
                      'assets/images/splash.png',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔴 Error message
                      Text(
                        _errorMessage ?? '',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔁 Retry button
                      ElevatedButton(
                        onPressed: _startProcess,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          "try_again".tr(),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
