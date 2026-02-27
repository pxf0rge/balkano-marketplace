import 'package:Balkano/features/search/widgets/chips.dart';
import 'package:Balkano/features/search/widgets/sheet_handle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            children: [
              const SheetHandle(),
              const SizedBox(height: 16),

              Text(
                "category".tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ChipsRow(
                items: ["filter_all".tr(), "fashion".tr(), "electronics".tr()],
              ),

              const SizedBox(height: 24),

              Text(
                "price_range".tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ChipsRow(
                items: [
                  "filter_all".tr(),
                  "under_5000".tr(),
                  "range_5000_10000".tr(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
