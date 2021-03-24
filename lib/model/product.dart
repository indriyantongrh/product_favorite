// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.id,
    this.name,
    this.category,
    this.imageUrl,
    this.oldPrice,
    this.price,
  });

  int id;
  String name;
  Category category;
  String imageUrl;
  String oldPrice;
  String price;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    category: categoryValues.map[json["category"]],
    imageUrl: json["imageUrl"],
    oldPrice: json["oldPrice"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category": categoryValues.reverse[category],
    "imageUrl": imageUrl,
    "oldPrice": oldPrice,
    "price": price,
  };
}

enum Category { ACCESSORIES, MEN, WOMEN }

final categoryValues = EnumValues({
  "Accessories": Category.ACCESSORIES,
  "Men": Category.MEN,
  "Women": Category.WOMEN
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
