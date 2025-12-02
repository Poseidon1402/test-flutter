import 'package:equatable/equatable.dart';
import 'product.dart';

enum LiveEventStatus { scheduled, live, ended }

class LiveEvent extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime? endTime;
  final LiveEventStatus status;
  final String sellerName;
  final List<Product> products;
  final Product? featuredProduct;
  final int viewerCount;
  final String? streamUrl;
  final String? replayUrl;
  final String thumbnailUrl;

  const LiveEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.sellerName,
    required this.products,
    this.featuredProduct,
    this.viewerCount = 0,
    this.streamUrl,
    this.replayUrl,
    required this.thumbnailUrl,
  });

  factory LiveEvent.fromJson(Map<String, dynamic> json, List<Product> allProducts) {
    final productIds = (json['products'] as List<dynamic>).cast<String>();
    final products = allProducts.where((p) => productIds.contains(p.id)).toList();
    final featuredId = json['featuredProduct'] as String?;
    final featured = featuredId == null
        ? null
        : products.firstWhere(
            (p) => p.id == featuredId,
            orElse: () => products.isNotEmpty ? products.first : allProducts.first,
          );

    return LiveEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      status: LiveEventStatus.values
          .firstWhere((e) => e.name == (json['status'] as String)),
      sellerName: (json['seller'] as Map<String, dynamic>)['name'] as String,
      products: products,
      featuredProduct: featured,
      viewerCount: json['viewerCount'] as int? ?? 0,
      streamUrl: json['streamUrl'] as String?,
      replayUrl: json['replayUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, status, viewerCount];
}
