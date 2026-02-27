import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../data/models/product.dart';

class ProductRemoteDatasource {
  final SupabaseClient client;

  ProductRemoteDatasource(this.client);

  Future<List<Product>> getAllProducts() async {
    final data = await client
        .from('products')
        .select('*, seller_data:users!products_seller_fkey(*)')
        .order('created_at', ascending: false);

    var result = (data as List).map((json) => Product.fromJson(json)).toList();

    return result;
  }
}
