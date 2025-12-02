part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatStarted extends ChatEvent {
  final String eventId;

  const ChatStarted(this.eventId);

  @override
  List<Object?> get props => [eventId];
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
  final bool isVendor;
  final ChatMessage? replyTo;

  const ChatMessageSent({
    required this.message,
    required this.senderId,
    required this.senderName,
    this.isVendor = false,
    this.replyTo,
  });

  @override
  List<Object?> get props => [message, senderId, senderName, isVendor, replyTo];
}
