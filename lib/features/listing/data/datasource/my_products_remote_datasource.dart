import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../data/models/product.dart';

class MyProductsRemoteDatasource {
  final SupabaseClient client;

  MyProductsRemoteDatasource(this.client);

  Future<List<Product>> getMyProducts() async {
    final uid = client.auth.currentUser!.id;

    final data = await client
        .from('products')
        .select('*, seller_data:users!products_seller_fkey(*)')
        .eq('seller', uid)
        .order('created_at', ascending: false);

    return (data as List).map((json) => Product.fromJson(json)).toList();
  }
}
