// import 'package:Balkano/features/search/widgets/filter_sheet.dart';
import 'package:Balkano/providers/search_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        context.read<SearchProvider>().updateQuery(value);
      },
      decoration: InputDecoration(
        hintText: "search_items".tr(),
        prefixIcon: const Icon(Icons.search),

        // suffixIcon: GestureDetector(
        //   onTap: () => _openFilterSheet(context),
        //   child: Container(
        //     margin: const EdgeInsets.all(6),
        //     decoration: BoxDecoration(
        //       color: Colors.grey.shade300,
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //     child: const Icon(Icons.tune),
        //   ),
        // ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// void _openFilterSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (_) {
//       return const FilterSheet();
//     },
//   );
// }
