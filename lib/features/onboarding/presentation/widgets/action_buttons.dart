import 'package:Balkano/features/auth/presentation/pages/login_page.dart';
import 'package:Balkano/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

/// Login action buttons
class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Primary filled button
        SizedBox(
          height: AppSizes.buttonHeight,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignupPage();
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              ),
            ),
            child: Text(AppStrings.registerButton),
          ),
        ),

        const SizedBox(height: AppSizes.verticalSpacing),

        /// Secondary outlined button
        SizedBox(
          height: AppSizes.buttonHeight,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginPage();
                  },
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              foregroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              ),
            ),
            child: Text(AppStrings.loginButton),
          ),
        ),
      ],
    );
  }
}
