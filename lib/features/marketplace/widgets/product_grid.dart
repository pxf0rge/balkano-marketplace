import 'package:Balkano/data/models/product.dart';
import 'package:Balkano/providers/market_search_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> allProducts;
  final Function(Product)? onEdit;
  final Function(Product)? onDelete;
  final String? categoryFilter;

  const ProductGrid({
    super.key,
    required this.allProducts,
    this.onEdit,
    this.onDelete,
    this.categoryFilter,
  });

  @override
  Widget build(BuildContext context) {
    final searchQuery = context.watch<MarketSearchProvider>().query;
    final normalizedQuery = searchQuery.toLowerCase();
    final filteredProducts = allProducts.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(normalizedQuery);
      final matchesCategory = categoryFilter == null ||
          categoryFilter == 'all' ||
          product.category == categoryFilter;
      return matchesSearch && matchesCategory;
    }).toList();
    if (filteredProducts.isNotEmpty) {
      return MasonryGridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 139,
          top: 24,
        ),
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        mainAxisSpacing: 12,

        crossAxisSpacing: 12,
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: filteredProducts[index],
            onEdit: onEdit,
            onDelete: (p) => onDelete!(p),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          "no_products_found".tr(),
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }
  }
}
