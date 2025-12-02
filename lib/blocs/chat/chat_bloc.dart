import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/chat_message.dart';
import '../../services/mock_socket_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MockSocketService socket;
  StreamSubscription<ChatMessage>? _sub;

  ChatBloc({required this.socket}) : super(const ChatState.initial()) {
    on<ChatStarted>(_onStarted);
    on<ChatMessageReceived>(_onMessageReceived);
    on<ChatMessageSent>(_onMessageSent);
  }

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    await _sub?.cancel();
    _sub = socket.chatStream.listen((message) {
      add(ChatMessageReceived(message));
    });
  }

  void _onMessageReceived(
    ChatMessageReceived event,
    Emitter<ChatState> emit,
  ) {
    final updated = List<ChatMessage>.from(state.messages)..add(event.message);
    emit(state.copyWith(messages: updated));
  }

  Future<void> _onMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    await socket.sendChatMessage(
      event.message,
      senderId: event.senderId,
      senderName: event.senderName,
      isVendor: event.isVendor,
      replyTo: event.replyTo,
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
