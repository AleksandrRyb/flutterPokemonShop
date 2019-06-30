import 'package:meta/meta.dart';

class Pokemon {
  String id;
  String name;
  String description;
  num price;
  Map<String, dynamic> picture;

  Pokemon({
    @required this.id, @required this.name, @required this.description, @required this.price, @required this.picture
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      picture: json['picture']
    );
  }
}

