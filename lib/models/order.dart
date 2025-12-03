import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final Map<String, String>? selectedVariations;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    this.selectedVariations,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      selectedVariations:
          (json['selectedVariations'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  @override
  List<Object?> get props => [productId, name, quantity, price, selectedVariations];
}

class Order extends Equatable {
  final String id;
  final String userId;
  final String liveEventId;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double total;
  final String status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.userId,
    required this.liveEventId,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      liveEventId: json['liveEventId'] as String,
      items: itemsJson
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      shipping: (json['shipping'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        liveEventId,
        items,
        subtotal,
        shipping,
        total,
        status,
        createdAt,
      ];
}
