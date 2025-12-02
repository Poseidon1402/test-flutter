import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/chat_message.dart';
import '../../services/socket_io_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SocketIoService socket;
  StreamSubscription<ChatMessage>? _sub;

  ChatBloc({required this.socket}) : super(const ChatState.initial()) {
    on<ChatStarted>(_onStarted);
    on<ChatMessageReceived>(_onMessageReceived);
    on<ChatMessageSent>(_onMessageSent);
  }

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    await _sub?.cancel();
    socket.connect(baseUrl: 'http://localhost:8000');
    socket.joinRoom(room: event.roomId, username: 'user123');

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
    socket.sendMessage(
      room: event.roomId,
      userId: event.senderId,
      username: event.senderName,
      message: event.message,
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
