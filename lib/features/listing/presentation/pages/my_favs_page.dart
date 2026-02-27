import 'package:Balkano/data/models/product.dart';
import 'package:Balkano/features/listing/widgets/my_listings_app_bar.dart';
import 'package:Balkano/features/marketplace/data/datasource/favorites_remote_datasource.dart';
import 'package:Balkano/features/marketplace/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyFavsPage extends StatefulWidget {
  const MyFavsPage({super.key});

  @override
  State<MyFavsPage> createState() => _MyFavsPageState();
}

class _MyFavsPageState extends State<MyFavsPage> {
  List<Product> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final datasource = FavoritesRemoteDatasource(Supabase.instance.client);

      final products = await datasource.getMyFavorites();

      if (!mounted) return;

      setState(() {
        _favorites = products;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const MyListingsAppBar(),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ProductGrid(allProducts: _favorites),
          ),
        ],
      ),
    );
  }
}
