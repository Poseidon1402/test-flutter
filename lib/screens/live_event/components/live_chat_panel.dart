part of '../live_event_screen.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D2E),
        border: Border(
          left: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'Chat en direct',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF9D4EDD),
                  size: 24,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final isMe = message.senderId == currentUserId;
                    return _ChatMessageTile(message: message, isMe: isMe);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Envoyer un message...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2A2D3E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
