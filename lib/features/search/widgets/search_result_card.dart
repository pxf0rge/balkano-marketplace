import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/data/models/product.dart';
import 'package:Balkano/features/marketplace/presentation/pages/listing_details_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchResultCard extends StatelessWidget {
  final Product product;
  const SearchResultCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          await Supabase.instance.client.from('users').select('id').limit(1);

          if (!context.mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListingDetailsPage(product: product),
            ),
          );
        } catch (e) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("no_internet".tr())));
        }
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: productResult(),
      ),
    );
  }

  Row productResult() {
    return Row(
      children: [
        /// Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(color: Colors.grey.shade300),
            child: Image.network(product.imageUrls.first, fit: BoxFit.cover),
          ),
        ),

        const SizedBox(width: 12),

        /// Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.red),
                  const SizedBox(width: 4),
                  Text(product.location, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),

        /// Price
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.priceBadge,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "€ ${product.price}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
