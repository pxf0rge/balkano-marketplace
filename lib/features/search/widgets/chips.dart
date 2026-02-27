import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChipsRow extends StatelessWidget {
  final List<String> items;

  const ChipsRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((e) {
        final bool selected = e == "filter_all".tr();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            e,
            style: TextStyle(color: selected ? Colors.white : Colors.black),
          ),
        );
      }).toList(),
    );
  }
}
