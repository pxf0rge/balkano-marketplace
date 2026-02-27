import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';

/// Top hero image section with rounded bottom corners
class HeroImageSection extends StatelessWidget {
  const HeroImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSizes.heroRadius),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSizes.heroRadius),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          width: double.infinity,
          child: Image.asset("assets/images/hero_image.jpg", fit: BoxFit.cover),
        ),
      ),
    );
  }
}
