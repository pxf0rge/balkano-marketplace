import 'package:Balkano/data/models/product.dart';

class User {
  final String id;
  String name;
  String email;
  String phone;
  String location;
  double rating;
  int salesCount;
  List<Product>? products;
  List<Product>? listings;
  int reviewsCount;
  String? profileImageUrl;
  final String registerDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.rating,
    required this.salesCount,
    required this.products,
    required this.listings,
    required this.reviewsCount,
    this.profileImageUrl,
    required this.registerDate,
  });

  User copy({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    double? rating,
    int? salesCount,
    List<Product>? products,
    List<Product>? listings,
    int? reviewsCount,
    String? profileImageUrl,
    String? registerDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      salesCount: salesCount ?? this.salesCount,
      products: products ?? this.products,
      listings: listings ?? this.listings,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      registerDate: registerDate ?? this.registerDate,
    );
  }

  void updateFrom(User other) {
    name = other.name;
    email = other.email;
    phone = other.phone;
    location = other.location;
    rating = other.rating;
    salesCount = other.salesCount;
    products = other.products;
    listings = other.listings;
    reviewsCount = other.reviewsCount;
    profileImageUrl = other.profileImageUrl;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      location: json['location'],
      rating: (json['rating'] ?? 0).toDouble(),
      salesCount: json['sold_count'] ?? 0,
      products: null,
      listings: null,
      reviewsCount: json['review_count'] ?? 0,
      profileImageUrl: json['profile_image'],
      registerDate: json['register_date'],
    );
  }
}
