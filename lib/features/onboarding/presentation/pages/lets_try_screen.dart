import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/action_buttons.dart';
import '../widgets/hero_image_section.dart';

/// Lets Try screen (Onboarding / Auth entry)
class LetsTryScreen extends StatelessWidget {
  const LetsTryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const HeroImageSection(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.title,
                    style: const TextStyle(
                      fontSize: AppSizes.titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.subtitle,
                    style: const TextStyle(
                      fontSize: AppSizes.subtitleFontSize,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  const ActionButtons(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
