import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/data/models/product.dart';
import 'package:Balkano/features/marketplace/data/datasource/product_remote_datasource.dart';
import 'package:Balkano/features/marketplace/data/repositories/product_repository_impl.dart';
import 'package:Balkano/features/marketplace/domain/usecases/get_all_products_usecase.dart';
import 'package:Balkano/features/marketplace/widgets/marketplace_app_bar.dart';
import 'package:Balkano/features/marketplace/widgets/product_grid.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage>
    with WidgetsBindingObserver {
  List<Product> _products = [];
  bool _isLoading = true;
  final client = Supabase.instance.client;
  String _selectedCategoryFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setOnline();
    _loadProducts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _setOffline();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setOnline();
    } else {
      _setOffline();
    }
  }

  Future<void> _setOnline() async {
    final user = client.auth.currentUser;
    if (user == null) return;

    await client.from('presence').upsert({
      'user_id': user.id,
      'is_online': true,
      'last_seen': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _setOffline() async {
    final user = client.auth.currentUser;
    if (user == null) return;

    await client.from('presence').upsert({
      'user_id': user.id,
      'is_online': false,
      'last_seen': DateTime.now().toIso8601String(),
    });
  }

  Widget _buildCategoryFilterChip(String value, String label) {
    final isSelected = _selectedCategoryFilter == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 13,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.fieldBackground,
      checkmarkColor: Colors.white,
      pressElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      onSelected: (_) {
        setState(() {
          _selectedCategoryFilter = value;
        });
      },
    );
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
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          const MarketplaceAppBar(),
          Container(
            width: double.infinity,
            color: AppColors.fieldBackground,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryFilterChip('all', "filter_all".tr()),
                  const SizedBox(width: 8),
                  _buildCategoryFilterChip(
                      'product', "category_products".tr()),
                  const SizedBox(width: 8),
                  _buildCategoryFilterChip(
                      'service', "category_services".tr()),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _loadProducts(),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ProductGrid(
                      allProducts: _products,
                      categoryFilter: _selectedCategoryFilter,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
