import 'package:cached_network_image/cached_network_image.dart';

class AppCacheManager {
  AppCacheManager._();

  static final AppCacheManager instance = AppCacheManager._();

  /// cache for user profiles
  final Map<String, Map<String, dynamic>> profileCache = {};

  /// cache for product images
  final Map<String, String> productImageCache = {};

  CachedNetworkImageProvider getImage(String url) {
    return CachedNetworkImageProvider(url);
  }

  void cacheProfile(String userId, Map<String, dynamic> profile) {
    profileCache[userId] = profile;
  }

  Map<String, dynamic>? getProfile(String userId) {
    return profileCache[userId];
  }

  void cacheProductImage(String productId, String imageUrl) {
    productImageCache[productId] = imageUrl;
  }

  String? getProductImage(String productId) {
    return productImageCache[productId];
  }
}
