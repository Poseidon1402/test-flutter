import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/live_event/live_event_bloc.dart';
import '../../models/chat_message.dart';
import '../../services/mock_api_service.dart';
import '../../services/mock_socket_service.dart';
import '../../services/socket_io_service.dart';

class LiveEventScreen extends StatefulWidget {
  final String eventId;

  const LiveEventScreen({super.key, required this.eventId});

  @override
  State<LiveEventScreen> createState() => _LiveEventScreenState();
}

class _LiveEventScreenState extends State<LiveEventScreen> {
  late final String _userId;
  late final String _userName;

  @override
  void initState() {
    super.initState();
    final random = Random();
    final suffix = random.nextInt(9999).toString().padLeft(4, '0');
    _userId = 'user_$suffix';
    _userName = 'User $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final api = MockApiService();
    final mockSocket = MockSocketService();
    final ioSocket = SocketIoService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LiveEventBloc>(
          create: (_) => LiveEventBloc(api: api, socket: mockSocket)
            ..add(LiveEventOpened(widget.eventId)),
        ),
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(socket: ioSocket)
            ..add(ChatStarted(widget.eventId)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Live Event')),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(flex: 2, child: _LiveVideoAndProducts()),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 1,
                child: _LiveChatPanel(
                  currentUserId: _userId,
                  currentUserName: _userName,
                  roomId: widget.eventId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiveVideoAndProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveEventBloc, LiveEventState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }
        final event = state.liveEvent;
        if (event == null) {
          return const Center(child: Text('Event not found'));
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: Text(
                    event.title,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.remove_red_eye, size: 16),
                    const SizedBox(width: 4),
                    Text('${state.viewerCount}'),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final product = event.products[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    leading: SizedBox(
                      width: 56,
                      height: 56,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(product.currentPrice.toStringAsFixed(2)),
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        // TODO: add to cart
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: event.products.length,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LiveChatPanel extends StatelessWidget {
  final String currentUserId;
  final String currentUserName;
  final String roomId;

  const _LiveChatPanel({
    required this.currentUserId,
    required this.currentUserName,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.messages.length,
                itemBuilder: (context, index) {
                  final message = state.messages[index];
                  return _ChatMessageTile(message: message);
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Send a message...',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {

                  final text = controller.text.trim();
                  if (text.isEmpty) return;
                  context.read<ChatBloc>().add(
                        ChatMessageSent(
                          message: text,
                          senderId: currentUserId,
                          senderName: currentUserName,
                          roomId: roomId,
                        ),
                      );
                  controller.clear();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatMessageTile extends StatelessWidget {
  final ChatMessage message;

  const _ChatMessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    // NOTE: alignment is handled generically; we keep all messages
    // left-aligned for now since multiple browser windows are involved.
    const bool isMe = false;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.senderName,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 2),
            Text(message.message),
          ],
        ),
      ),
    );
  }
}
