import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/features/marketplace/widgets/search_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MarketplaceAppBar extends StatelessWidget {
  const MarketplaceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 16),
      decoration: const BoxDecoration(color: AppColors.darkHeader),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "app_name".tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const SearchField(),
        ],
      ),
    );
  }
}
