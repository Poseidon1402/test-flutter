import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter/models/product.dart';

void main() {
  group('Product.fromJson', () {
    test('parses full product with salePrice and variations', () {
      final map = {
        'id': 'prod_001',
        'name': 'Robe d\'été légère',
        'description': 'Robe fluide et légère parfaite pour l\'été.',
        'price': 59.99,
        'salePrice': 39.99,
        'images': [
          'https://example.com/img1.jpg',
          'https://example.com/img2.jpg',
        ],
        'thumbnail': 'https://example.com/thumb.jpg',
        'stock': 10,
        'variations': {
          'size': ['S', 'M', 'L'],
          'color': ['Rouge', 'Blanc'],
        },
        'isFeatured': true,
        'featuredAt': '2025-11-15T12:00:00Z',
      };

      final product = Product.fromJson(map);

      expect(product.id, 'prod_001');
      expect(product.name, "Robe d'été légère");
      expect(product.description.contains('Robe fluide'), isTrue);
      expect(product.price, 59.99);
      expect(product.salePrice, 39.99);
      expect(product.images.length, 2);
      expect(product.thumbnail, contains('thumb'));
      expect(product.stock, 10);
      expect(product.variations?['size'], isNotNull);
      expect(product.isFeatured, isTrue);
      expect(product.featuredAt, isNotNull);
      expect(product.currentPrice, 39.99);
      expect(product.isOnSale, isTrue);
    });
  });
}
