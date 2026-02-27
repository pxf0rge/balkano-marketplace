import 'package:Balkano/data/enums/product_conditions.dart';
import 'package:Balkano/data/models/user.dart';

class Product {
  final String name;
  final double price;
  final List<String> imageUrls;
  final String description;
  final ProductConditions condition;
  final String id;
  final User seller;
  final String color;
  final String category;
  final DateTime datePosted;
  final String location;
  final int views;

  Product({
    required this.name,
    required this.price,
    required this.imageUrls,
    required this.description,
    required this.condition,
    required this.id,
    required this.seller,
    required this.color,
    required this.category,
    required this.datePosted,
    required this.location,
    required this.views,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      description: json['description'],
      id: json['id'],
      name: json['title'],
      price: (json['price'] as num).toDouble(),
      imageUrls: List<String>.from(json['images'] ?? []),
      location: json['location'],
      color: json['color'],
      condition: ProductConditionsExtension.fromString(json['condition']),
      views: json['view_count'] ?? 0,
      seller: User.fromJson(json['seller_data']), // حالا object کامل است
      datePosted: DateTime.parse(json['created_at']),
      category: (json['category'] ?? 'product') as String,
    );
  }
}
