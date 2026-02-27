import 'package:Balkano/data/models/product.dart';
import 'package:Balkano/features/marketplace/data/datasource/product_remote_datasource.dart';
import 'package:Balkano/features/marketplace/data/repositories/product_repository_impl.dart';
import 'package:Balkano/features/marketplace/domain/usecases/get_all_products_usecase.dart';
import 'package:Balkano/features/search/widgets/search_header.dart';
import 'package:Balkano/features/search/widgets/search_result_card.dart';
import 'package:Balkano/providers/search_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> _allProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final datasource = ProductRemoteDatasource(Supabase.instance.client);
      final repo = ProductRepositoryImpl(datasource);
      final usecase = GetAllProductsUseCase(repo);

      final products = await usecase();

      if (!mounted) return;

      setState(() {
        _allProducts = products;
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
    final searchQuery = context.watch<SearchProvider>().query;

    final filteredProducts = _allProducts.where((product) {
      return product.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SearchHeader(),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadProducts,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            "no_results_found".tr(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 115,
                        top: 24,
                        left: 24,
                        right: 24,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return SearchResultCard(
                          product: filteredProducts[index],
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
