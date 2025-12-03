import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter/models/chat_message.dart';

void main() {
  group('ChatMessage.fromJson', () {
    test('parses message with reactions and optional vendor flag', () {
      final map = {
        'id': 'msg_1',
        'senderId': 'user_1',
        'senderName': 'Bob',
        'message': 'Hello world',
        'timestamp': '2025-12-01T10:00:00Z',
        'isVendor': true,
        'reactions': ['like', 'love'],
      };

      final msg = ChatMessage.fromJson(map);

      expect(msg.id, 'msg_1');
      expect(msg.senderId, 'user_1');
      expect(msg.senderName, 'Bob');
      expect(msg.message, 'Hello world');
      expect(msg.timestamp.isUtc, isTrue);
      expect(msg.isVendor, isTrue);
      expect(msg.reactions.length, 2);
    });

    test('parses message with replyTo object (partial)', () {
      final map = {
        'id': 'msg_2',
        'senderId': 'user_2',
        'senderName': 'Alice',
        'message': 'Replying',
        'timestamp': '2025-12-01T10:05:00Z',
        'replyTo': {
          'id': 'msg_1',
          'sender': 'Bob',
          'message': 'Hello world'
        },
      };

      final msg = ChatMessage.fromJson(map);

      expect(msg.replyTo, isNotNull);
      expect(msg.replyTo!.id, 'msg_1');
      expect(msg.replyTo!.senderName, 'Bob');
      expect(msg.replyTo!.message, 'Hello world');
    });
  });
}
