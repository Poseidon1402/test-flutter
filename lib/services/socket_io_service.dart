import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/chat_message.dart';

class SocketIoService {
  IO.Socket? _socket;
  final _chatController = StreamController<ChatMessage>.broadcast();
  final _viewerCountController =
      StreamController<ViewerCountUpdate>.broadcast();

  Stream<ChatMessage> get chatStream => _chatController.stream;
  Stream<ViewerCountUpdate> get viewerCountStream =>
      _viewerCountController.stream;

  void connect({String baseUrl = 'http://localhost:8000'}) {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      print('Socket connected');
    });

    _socket!.onDisconnect((_) {
      print('Socket disconnected');
    });

    // IMPORTANT: listen to the same event name the backend emits: "message"
    _socket!.on('message', (data) {
      if (data is Map) {
        final msg = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: (data['userId'] ?? '') as String,
          senderName: (data['username'] ?? '') as String,
          message: (data['message'] ?? '') as String,
          timestamp: DateTime.now(),
        );
        _chatController.add(msg);
      }
    });

    // Listen for viewer count updates
    _socket!.on('viewer_count', (data) {
      print('Viewer count data received: $data');
      if (data is Map && data['room'] != null && data['count'] != null) {
        final room = data['room'].toString();
        final count = int.tryParse(data['count'].toString());
        if (count != null) {
          _viewerCountController.add(
            ViewerCountUpdate(room: room, count: count),
          );
          
        }
      }
    });

    _socket!.connect();
  }

  void joinRoom({required String room, required String username}) {
    _socket?.emit('join', {'room': room, 'username': username});
  }

  // Explicitly start watching a live event (affects viewer_count)
  void watchLive({required String room, required String username}) {
    _socket?.emit('watch_live', {'room': room, 'username': username});
  }

  // Stop watching a live event (decrements viewer_count)
  void leaveLive({required String room}) {
    _socket?.emit('leave_live', {'room': room});
  }

  void sendMessage({
    required String room,
    required String userId,
    required String username,
    required String message,
  }) {
    _socket?.emit('message', {
      'room': room,
      'userId': userId,
      'username': username,
      'message': message,
    });
  }

  void dispose() {
    _socket?.dispose();
    _chatController.close();
    _viewerCountController.close();
  }
}

class ViewerCountUpdate {
  final String room;
  final int count;
  ViewerCountUpdate({required this.room, required this.count});
}
