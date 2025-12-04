import 'dart:async';
import 'dart:math';

import '../models/chat_message.dart';

class MockSocketService {
  static final MockSocketService _instance = MockSocketService._internal();
  factory MockSocketService() => _instance;
  MockSocketService._internal();

  final _chatController = StreamController<ChatMessage>.broadcast();
  final _viewerCountController = StreamController<int>.broadcast();

  Stream<ChatMessage> get chatStream => _chatController.stream;
  Stream<int> get viewerCountStream => _viewerCountController.stream;

  Timer? _viewerTimer;
  String? _currentEventId;
  int _baseViewerCount = 0;
  final _random = Random();

  Future<void> joinLiveEvent(String eventId, {int initialViewers = 0}) async {
    _currentEventId = eventId;
    _baseViewerCount = initialViewers;
    _startViewerSimulation();
  }

  void leaveLiveEvent(String eventId) {
    if (_currentEventId == eventId) {
      _currentEventId = null;
      _viewerTimer?.cancel();
      _viewerTimer = null;
    }
  }

  Future<void> sendChatMessage(
    String message, {
    required String senderId,
    required String senderName,
    bool isVendor = false,
    ChatMessage? replyTo,
  }) async {
    if (_currentEventId == null) {
      throw Exception('Not connected to an event');
    }

    await Future.delayed(const Duration(milliseconds: 150));

    final chatMessage = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      senderName: senderName,
      message: message,
      timestamp: DateTime.now(),
      isVendor: isVendor,
      replyTo: replyTo,
    );

    _chatController.add(chatMessage);
  }

  void _startViewerSimulation() {
    _viewerTimer?.cancel();
    _viewerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentEventId == null) {
        timer.cancel();
        return;
      }
      final delta = _random.nextInt(11) - 5; // -5..+5
      _baseViewerCount = (_baseViewerCount + delta).clamp(0, 9999);
      _viewerCountController.add(_baseViewerCount);
    });
  }

  void dispose() {
    _viewerTimer?.cancel();
    _chatController.close();
    _viewerCountController.close();
  }
}
