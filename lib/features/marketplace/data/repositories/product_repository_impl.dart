import 'package:Balkano/data/models/product.dart';
import 'package:Balkano/features/marketplace/data/datasource/product_remote_datasource.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;

  ProductRepositoryImpl(this.remote);

  @override
  Future<List<Product>> getAllProducts() {
    return remote.getAllProducts();
  }
}
