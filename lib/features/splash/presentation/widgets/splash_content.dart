import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';

/// Central splash content (logo & subtitle)
class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.appName,
          style: const TextStyle(
            fontSize: AppSizes.titleFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSizes.contentSpacing),
        Text(
          AppStrings.splashSubtitle,
          style: const TextStyle(
            fontSize: AppSizes.subtitleFontSize,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
