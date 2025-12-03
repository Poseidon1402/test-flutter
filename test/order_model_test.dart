import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter/models/order.dart';

void main() {
  group('Order.fromJson', () {
    test('parses order with items and totals', () {
      final map = {
        'id': 'ord_1',
        'userId': 'user_123',
        'liveEventId': 'evt_001',
        'items': [
          {
            'productId': 'prod_001',
            'name': 'Robe',
            'quantity': 2,
            'price': 39.99,
            'selectedVariations': {'size': 'S', 'color': 'Blanc'},
          },
          {
            'productId': 'prod_002',
            'name': 'Chaussures',
            'quantity': 1,
            'price': 79.99,
          },
        ],
        'subtotal': 159.97,
        'shipping': 9.90,
        'total': 169.87,
        'status': 'paid',
        'createdAt': '2025-12-01T11:00:00Z',
      };

      final order = Order.fromJson(map);

      expect(order.id, 'ord_1');
      expect(order.userId, 'user_123');
      expect(order.liveEventId, 'evt_001');
      expect(order.items.length, 2);
      expect(order.items.first.productId, 'prod_001');
      expect(order.items.first.selectedVariations?['size'], 'S');
      expect(order.subtotal, 159.97);
      expect(order.shipping, 9.90);
      expect(order.total, 169.87);
      expect(order.status, 'paid');
      expect(order.createdAt.isUtc, isTrue);
    });
  });
}
