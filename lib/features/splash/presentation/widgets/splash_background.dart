import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Background widget containing decorative curved shapes
class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Top-left light grey arc
        Positioned(
          top: -80,
          left: -80,
          child: Container(
            width: AppSizes.largeCircleSize,
            height: AppSizes.largeCircleSize,
            decoration: const BoxDecoration(
              color: AppColors.lightGrey,
              shape: BoxShape.circle,
            ),
          ),
        ),

        /// Top-left dark blue arc
        Positioned(
          top: -40,
          left: -40,
          child: Container(
            width: AppSizes.smallCircleSize,
            height: AppSizes.smallCircleSize,
            decoration: const BoxDecoration(
              color: AppColors.darkBlue,
              shape: BoxShape.circle,
            ),
          ),
        ),

        /// Bottom-right light grey arc
        Positioned(
          bottom: -80,
          right: -80,
          child: Container(
            width: AppSizes.largeCircleSize,
            height: AppSizes.largeCircleSize,
            decoration: const BoxDecoration(
              color: AppColors.lightGrey,
              shape: BoxShape.circle,
            ),
          ),
        ),

        /// Bottom-right dark blue arc
        Positioned(
          bottom: -40,
          right: -40,
          child: Container(
            width: AppSizes.smallCircleSize,
            height: AppSizes.smallCircleSize,
            decoration: const BoxDecoration(
              color: AppColors.darkBlue,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
