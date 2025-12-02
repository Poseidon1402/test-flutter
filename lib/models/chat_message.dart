import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isVendor;
  final ChatMessage? replyTo;
  final List<String> reactions;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.isVendor = false,
    this.replyTo,
    this.reactions = const [],
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isVendor: json['isVendor'] as bool? ?? false,
      replyTo: json['replyTo'] != null
          ? ChatMessage(
              id: (json['replyTo'] as Map<String, dynamic>)['id'] as String,
              senderId: '',
              senderName: (json['replyTo'] as Map<String, dynamic>)['sender']
                  as String,
              message:
                  (json['replyTo'] as Map<String, dynamic>)['message'] as String,
              timestamp: DateTime.now(),
            )
          : null,
      reactions:
          (json['reactions'] as List<dynamic>? ?? const []).cast<String>(),
    );
  }

  @override
  List<Object?> get props => [id, senderId, message, timestamp, isVendor];
}
