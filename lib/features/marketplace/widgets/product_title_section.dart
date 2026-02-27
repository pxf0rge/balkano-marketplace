import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/data/models/product.dart';
import 'package:flutter/material.dart';

class ProductTitleSection extends StatelessWidget {
  final Product product;
  const ProductTitleSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
        ),

        const SizedBox(height: 6),

        _PriceTag(product: product),
      ],
    );
  }
}

class _PriceTag extends StatelessWidget {
  final Product product;
  const _PriceTag({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.priceBadge,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "€ ${product.price}",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
