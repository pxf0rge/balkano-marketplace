import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/core/constants/global_values.dart';
import 'package:Balkano/features/search/widgets/search_input.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
      color: AppColors.darkHeader,
      child: Column(
        children: [
          Row(
            children: [
              GlobalValues.currentUser != null &&
                      GlobalValues.currentUser!.profileImageUrl != null
                  ? CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        GlobalValues.currentUser!.profileImageUrl!,
                      ),
                    )
                  : const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white, size: 24),
                    ),

              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "hello".tr(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    GlobalValues.currentUser != null
                        ? GlobalValues.currentUser!.name
                        : "guest".tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 26),
          const SearchInput(),
        ],
      ),
    );
  }
}
