import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter/models/live_event.dart';
import 'package:test_flutter/models/product.dart';

void main() {
  group('LiveEvent.fromJson', () {
    test('parses event and resolves products', () {
      final products = [
        Product.fromJson({
          'id': 'prod_001',
          'name': 'Robe',
          'description': 'Belle robe',
          'price': 59.99,
          'images': ['i1'],
          'thumbnail': 't1',
          'stock': 5,
        }),
        Product.fromJson({
          'id': 'prod_002',
          'name': 'Chaussures',
          'description': 'Confortables',
          'price': 79.99,
          'images': ['i2'],
          'thumbnail': 't2',
          'stock': 3,
        }),
      ];

      final map = {
        'id': 'evt_001',
        'title': 'Démo Live',
        'description': 'Présentation produits',
        'startTime': '2025-12-01T12:00:00Z',
        'status': 'live',
        'seller': {'name': 'Vendor X'},
        'products': ['prod_001', 'prod_002'],
        'featuredProduct': 'prod_001',
        'viewerCount': 120,
        'thumbnailUrl': 'thumb_evt.jpg',
      };

      final event = LiveEvent.fromJson(map, products);

      expect(event.id, 'evt_001');
      expect(event.title, 'Démo Live');
      expect(event.status, LiveEventStatus.live);
      expect(event.sellerName, 'Vendor X');
      expect(event.products.length, 2);
      expect(event.featuredProduct?.id, 'prod_001');
      expect(event.viewerCount, 120);
      expect(event.thumbnailUrl, 'thumb_evt.jpg');
    });
  });
}
