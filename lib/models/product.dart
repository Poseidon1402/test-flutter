import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? salePrice;
  final List<String> images;
  final String thumbnail;
  final int stock;
  final Map<String, dynamic>? variations;
  final bool isFeatured;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.salePrice,
    required this.images,
    required this.thumbnail,
    required this.stock,
    this.variations,
    this.isFeatured = false,
  });

  double get currentPrice => salePrice ?? price;
  bool get isOnSale => salePrice != null && salePrice! < price;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      salePrice:
          json['salePrice'] != null ? (json['salePrice'] as num).toDouble() : null,
      images: (json['images'] as List<dynamic>).cast<String>(),
      thumbnail: json['thumbnail'] as String,
      stock: json['stock'] as int,
      variations: json['variations'] as Map<String, dynamic>?,
      isFeatured: json['isFeatured'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, name, price, salePrice, stock];
}
