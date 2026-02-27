import 'package:Balkano/data/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesRemoteDatasource {
  final SupabaseClient client;
  FavoritesRemoteDatasource(this.client);

  Future<bool> isFavorite(String productId) async {
    final uid = client.auth.currentUser!.id;

    final data = await client
        .from('user_favorites')
        .select()
        .eq('user_id', uid)
        .eq('product_id', productId)
        .maybeSingle();

    return data != null;
  }

  Future<List<Product>> getMyFavorites() async {
    final uid = client.auth.currentUser!.id;

    final data = await client
        .from('user_favorites')
        .select('products(*, seller_data:users!products_seller_fkey(*))')
        .eq('user_id', uid);

    final products = (data as List)
        .map((e) => Product.fromJson(e['products']))
        .toList();
    return products;
  }

  Future<void> addFavorite(String productId) async {
    final uid = client.auth.currentUser!.id;

    await client.from('user_favorites').insert({
      'user_id': uid,
      'product_id': productId,
    });
  }

  Future<void> removeFavorite(String productId) async {
    final uid = client.auth.currentUser!.id;

    await client
        .from('user_favorites')
        .delete()
        .eq('user_id', uid)
        .eq('product_id', productId);
  }
}
