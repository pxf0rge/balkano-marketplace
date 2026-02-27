import 'package:Balkano/data/models/user.dart';

class GlobalValues {
  static User? currentUser = User(
    id: "test",
    name: "Alireza Hasanzadeh",
    email: "pxforge@proton.me",
    phone: "09383559766",
    location: "Iran, Birjand",
    rating: 4.2,
    registerDate: DateTime.timestamp().toString(),
    salesCount: 13,
    products: [],
    listings: [],
    reviewsCount: 8,
  );
}
