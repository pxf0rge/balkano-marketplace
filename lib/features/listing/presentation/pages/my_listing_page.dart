import 'package:Balkano/data/models/product.dart';
import 'package:Balkano/features/listing/data/datasource/my_products_remote_datasource.dart';
import 'package:Balkano/features/listing/presentation/pages/edit_listing_page.dart';
import 'package:Balkano/features/listing/widgets/my_listings_app_bar.dart';
import 'package:Balkano/features/marketplace/widgets/product_grid.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyProducts();
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F1F1F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "delete_listing".tr(),
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            "delete_listing_confirm".tr(),
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                "cancel".tr(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                "delete".tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await Supabase.instance.client
        .from('products')
        .delete()
        .eq('id', product.id);

    _loadMyProducts();
  }

  Future<void> _openEdit(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditListingPage(product: product)),
    );

    if (result == true) {
      _loadMyProducts();
    }
  }

  Future<void> _loadMyProducts() async {
    try {
      final datasource = MyProductsRemoteDatasource(Supabase.instance.client);

      final products = await datasource.getMyProducts();

      if (!mounted) return;

      setState(() {
        _products = products;
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
                : ProductGrid(
                    allProducts: _products,
                    onDelete: _deleteProduct,
                    onEdit: _openEdit,
                  ),
          ),
        ],
      ),
    );
  }
}
