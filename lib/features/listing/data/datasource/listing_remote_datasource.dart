import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListingRemoteDatasource {
  final SupabaseClient client;
  ListingRemoteDatasource(this.client);

  // Upload images and return URLs
  Future<List<String>> uploadImages(List<File> images) async {
    final urls = <String>[];

    for (final image in images) {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';

      await client.storage.from('product-images').upload(fileName, image);

      final url = client.storage.from('product-images').getPublicUrl(fileName);

      urls.add(url);
    }

    return urls;
  }

  Future<void> createListing({
    required String title,
    required String description,
    required String color,
    required String condition,
    required String category,
    required double price,
    required String location,
    required List<String> imageUrls,
  }) async {
    final uid = client.auth.currentUser!.id;

    await client.from('products').insert({
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'color': color,
      'condition': condition,
      'category': category,
      'images': imageUrls,
      'seller': uid,
    });
  }
}
