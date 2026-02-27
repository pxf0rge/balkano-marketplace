import 'dart:ui';
import 'package:Balkano/data/models/product.dart';
import 'package:Balkano/features/marketplace/data/datasource/favorites_remote_datasource.dart';
import 'package:Balkano/features/marketplace/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailsHeaderImage extends StatefulWidget {
  final Product product;

  const DetailsHeaderImage({super.key, required this.product});

  @override
  State<DetailsHeaderImage> createState() => _DetailsHeaderImageState();
}

class _DetailsHeaderImageState extends State<DetailsHeaderImage> {
  bool _isFavorite = false;
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  Future<void> _toggleFavorite() async {
    final datasource = FavoritesRemoteDatasource(Supabase.instance.client);

    if (_isFavorite) {
      await datasource.removeFavorite(widget.product.id);
    } else {
      await datasource.addFavorite(widget.product.id);
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: const BoxDecoration(color: Color(0xFFDADADA)),
      child: Stack(
        children: [
          /// Slider
          PageView.builder(
            controller: _pageController,
            itemCount: widget.product.imageUrls.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.product.imageUrls[index],
                fit: BoxFit.fitHeight,
              );
            },
          ),

          /// Fav Button
          Positioned(
            top: 16,
            right: 16,
            child: GlassIconButton(
              icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
              onTap: _toggleFavorite,
            ),
          ),

          /// Back Button
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              child: const _GlassCircleButton(icon: Icons.arrow_back),
              onTap: () => Navigator.pop(context),
            ),
          ),

          /// View Count
          Positioned(
            bottom: 16,
            right: 16,
            child: _GlassCounter(
              _currentIndex,
              widget.product.imageUrls.length,
            ),
          ),

          /// Dots Indicator
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.product.imageUrls.length,
                (index) => _Dot(isActive: index == _currentIndex),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool isActive;

  const _Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _GlassCircleButton extends StatelessWidget {
  final IconData icon;

  const _GlassCircleButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.40),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        // filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

class _GlassCounter extends StatelessWidget {
  final int index;
  final int length;
  const _GlassCounter(this.index, this.length);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.image_sharp, color: Colors.black, size: 14),
              const SizedBox(width: 4),
              Text(
                "${index + 1} / $length",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
