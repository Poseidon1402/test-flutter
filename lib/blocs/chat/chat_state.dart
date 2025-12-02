part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<ChatMessage> messages;

  const ChatState({required this.messages});

  const ChatState.initial() : this(messages: const []);

  ChatState copyWith({List<ChatMessage>? messages}) {
    return ChatState(messages: messages ?? this.messages);
  }

  @override
  List<Object?> get props => [messages];
}
