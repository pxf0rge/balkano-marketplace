import 'package:Balkano/data/models/product.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final Product product;
  const InfoRow({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 16),
            const SizedBox(width: 4),
            Text(product.location),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.schedule, size: 16),
            const SizedBox(width: 4),
            Text(
              "${product.datePosted.year}-${product.datePosted.month}-${product.datePosted.day} ${product.datePosted.hour}:${product.datePosted.minute}",
            ),

            const SizedBox(width: 16),

            const Icon(Icons.remove_red_eye_outlined, size: 16),
            const SizedBox(width: 4),
            Text("${product.views} views"),
          ],
        ),
      ],
    );
  }
}
