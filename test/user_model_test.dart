import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter/models/user.dart';

void main() {
  group('User.fromJson', () {
    test('parses basic user', () {
      final map = {
        'id': 'user_123',
        'name': 'Alice',
        'email': 'alice@example.com',
      };

      final user = User.fromJson(map);

      expect(user.id, 'user_123');
      expect(user.name, 'Alice');
      expect(user.email, 'alice@example.com');
      expect(user.toJson(), map);
    });
  });
}
