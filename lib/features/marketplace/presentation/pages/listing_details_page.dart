import 'package:Balkano/data/enums/product_conditions.dart';
import 'package:Balkano/data/models/product.dart';
import 'package:Balkano/features/marketplace/widgets/attribute_tile.dart';
import 'package:Balkano/features/marketplace/widgets/contact_seller_button.dart';
import 'package:Balkano/features/marketplace/widgets/details_header_image.dart';
import 'package:Balkano/features/marketplace/widgets/info_row.dart';
import 'package:Balkano/features/marketplace/widgets/product_title_section.dart';
import 'package:Balkano/features/marketplace/widgets/seller_info_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ListingDetailsPage extends StatelessWidget {
  final Product product;

  const ListingDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            DetailsHeaderImage(product: product),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductTitleSection(product: product),

                      const SizedBox(height: 20),

                      InfoRow(product: product),

                      const SizedBox(height: 20),

                      AttributeTile(title: "color".tr(), value: product.color),

                      const SizedBox(height: 12),

                      AttributeTile(
                        title: "condition".tr(),
                        value: product.condition.toDbValue(),
                      ),

                      const SizedBox(height: 28),

                      Text(
                        "seller_information".tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      SellerInfoCard(user: product.seller),

                      const SizedBox(height: 32),

                      ContactSellerButton(
                        sellerId: product.seller.id,
                        sellerName: product.seller.name,
                        sellerAvatar: product.seller.profileImageUrl,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
