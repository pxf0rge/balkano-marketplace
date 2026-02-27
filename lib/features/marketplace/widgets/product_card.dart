import 'package:Balkano/core/cache/app_cache_manager.dart';
import 'package:Balkano/core/constants/app_colors.dart';
import 'package:Balkano/data/models/product.dart';
import 'package:Balkano/features/marketplace/data/datasource/favorites_remote_datasource.dart';
import 'package:Balkano/features/marketplace/presentation/pages/listing_details_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final Function(Product)? onEdit;
  final Function(Product)? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isOpening = false;
  bool _isFavorite = false;
  bool _isExpanded = false;

  Product get product => widget.product;

  @override
  void initState() {
    super.initState();

    /// کش کردن تصویر
    AppCacheManager.instance.cacheProductImage(
      product.id,
      product.imageUrls.first,
    );

    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final datasource =
        FavoritesRemoteDatasource(Supabase.instance.client);

    final result = await datasource.isFavorite(product.id);

    if (!mounted) return;

    setState(() => _isFavorite = result);
  }

  Future<void> _toggleFavorite() async {
    final datasource =
        FavoritesRemoteDatasource(Supabase.instance.client);

    if (_isFavorite) {
      await datasource.removeFavorite(product.id);
    } else {
      await datasource.addFavorite(product.id);
    }

    if (!mounted) return;

    setState(() => _isFavorite = !_isFavorite);
  }

  Future<void> _openDetails() async {
    if (_isOpening) return;

    setState(() => _isOpening = true);

    try {
      await Supabase.instance.client
          .from('users')
          .select('id')
          .limit(1);

      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ListingDetailsPage(product: widget.product),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("no_internet".tr())),
      );
    } finally {
      if (mounted) {
        setState(() => _isOpening = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardHeight = constraints.maxHeight;
            final maxExpandedHeight = cardHeight * 0.8;
            const collapsedHeight = 90.0;

            return Stack(
              children: [

                /// --------------------------------------------------
                /// 1️⃣ تصویر محصول
                /// --------------------------------------------------
                Positioned.fill(
                  child: Image(
                    image: AppCacheManager.instance.getImage(
                      product.imageUrls.first,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),

                /// --------------------------------------------------
                /// 2️⃣ Gesture کل کارت
                /// فقط برای تشخیص کلیک روی 20٪ بالایی
                /// --------------------------------------------------
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) {
                    final tapY = details.localPosition.dy;

                    if (_isExpanded &&
                        tapY < cardHeight * 0.2) {
                      setState(() => _isExpanded = false);
                    }
                  },
                  child: const SizedBox.expand(),
                ),

                /// --------------------------------------------------
                /// 3️⃣ Gesture تصویر برای رفتن به جزئیات
                /// فقط در حالت collapse فعال است
                /// --------------------------------------------------
                if (!_isExpanded)
                  GestureDetector(
                    onTap: _openDetails,
                    child: const SizedBox.expand(),
                  ),

                /// --------------------------------------------------
                /// 4️⃣ دکمه علاقه‌مندی
                /// --------------------------------------------------
                Positioned(
                  top: 12,
                  right: 12,
                  child: GlassIconButton(
                    icon: _isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        _isFavorite ? Colors.red : Colors.white,
                    onTap: _toggleFavorite,
                  ),
                ),

                /// --------------------------------------------------
                /// 5️⃣ باکس مشکی پایین (Animated)
                /// --------------------------------------------------
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      constraints: BoxConstraints(
                        maxHeight: _isExpanded
                            ? maxExpandedHeight
                            : collapsedHeight,
                      ),
                      decoration: BoxDecoration(
                        color:
                            Colors.black.withOpacity(0.80),
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white
                              .withOpacity(0.15),
                        ),
                      ),
                      child: Container(
                        padding:
                            const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.22),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),

                        /// اگر expanded شد و متن زیاد بود → اسکرول فعال شود
                        child: _isExpanded
                            ? SingleChildScrollView(
                                child: _buildTextContent(
                                    expanded: true),
                              )
                            : _buildTextContent(
                                expanded: false),
                      ),
                    ),
                  ),
                ),

                /// --------------------------------------------------
                /// 6️⃣ لودینگ هنگام باز شدن صفحه
                /// --------------------------------------------------
                if (_isOpening)
                  Positioned.fill(
                    child: Container(
                      color:
                          Colors.white.withOpacity(0.55),
                      child: const Center(
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// --------------------------------------------------
  /// ویجت جدا برای متن (قابل نگهداری)
  /// --------------------------------------------------
  Widget _buildTextContent({required bool expanded}) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                maxLines:
                    expanded ? null : 1,
                overflow: expanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 6),
            _GlassPriceTag(product: product),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          product.description,
          maxLines:
              expanded ? null : 1,
          overflow: expanded
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

/// --------------------------------------------------
/// Glass Icon Button
/// --------------------------------------------------
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(30),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color:
                Colors.black.withOpacity(0.40),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white
                  .withOpacity(0.4),
              width: 0.8,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// --------------------------------------------------
/// Glass Price Tag
/// --------------------------------------------------
class _GlassPriceTag extends StatelessWidget {
  final Product product;

  const _GlassPriceTag(
      {required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black
            .withOpacity(0.35),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              Colors.white.withOpacity(0.2),
        ),
      ),
      child: Text(
        "€ ${product.price}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }
}