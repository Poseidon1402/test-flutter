part of '../live_event_screen.dart';

class _ChatMessageTile extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _ChatMessageTile({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://picsum.photos/seed/${message.senderId}/200',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isMe ? const Color(0xFF9D4EDD) : Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe
                        ? const Color(0xFF9D4EDD).withOpacity(0.2)
                        : const Color(0xFF2A2D3E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isMe
                          ? const Color(0xFF9D4EDD).withOpacity(0.3)
                          : Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    message.message,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
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
