part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  final String roomId;

  const ChatStarted(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class ChatMessageReceived extends ChatEvent {
  final ChatMessage message;

  const ChatMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMessageSent extends ChatEvent {
  final String message;
  final String senderId;
  final String senderName;
  final String roomId;
  final bool isVendor;
  final ChatMessage? replyTo;

  const ChatMessageSent({
    required this.message,
    required this.senderId,
    required this.senderName,
    required this.roomId,
    this.isVendor = false,
    this.replyTo,
  });

  @override
  List<Object?> get props => [message, senderId, senderName, roomId, isVendor, replyTo];
}
