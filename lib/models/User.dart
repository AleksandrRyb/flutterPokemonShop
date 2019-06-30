import 'package:meta/meta.dart';

class User {
  String id, username, email, jwt, cartId, customerId;

  User({ @required this.id,
    @required this.email,
    @required this.jwt,
    @required this.username,
    @required this.cartId,
    @required this.customerId
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      jwt: json['jwt'],
      username: json['username'],
      cartId: json['cart_id'],
      customerId: json['customer_id']
    );
  }
}