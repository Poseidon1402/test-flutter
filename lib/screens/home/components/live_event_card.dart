part of '../home_screen.dart';

class _LiveEventCard extends StatelessWidget {
  final LiveEvent event;
  final LiveEventStatus status;

  const _LiveEventCard({required this.event, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Image with overlays (LIVE + viewers)
          _ImagePreview(
            status: status,
            thumbnailUrl: event.thumbnailUrl,
            viewerCount: event.viewerCount,
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Animé par ${event.sellerName.startsWith('@') ? event.sellerName : '@${event.sellerName}'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                if (status != LiveEventStatus.live)
                  Text(
                    _relativeTimeText(event, DateTime.now()),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Hide price on live cards; show only for scheduled/ended
                    if (status != LiveEventStatus.live &&
                        event.featuredProduct != null)
                      Text(
                        '\$${event.featuredProduct!.currentPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9D4EDD),
                          fontFamily: 'Poppins',
                        ),
                      )
                    else
                      const SizedBox.shrink(),

                    _buildActionButton(context, status),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, LiveEventStatus status) {
    switch (status) {
      case LiveEventStatus.live:
        return ElevatedButton.icon(
          onPressed: () => context.go('/live/${event.id}'),
          icon: const Icon(Icons.play_arrow, size: 18),
          label: const Text('Regarder'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9D4EDD),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: StadiumBorder(),
            elevation: 0,
          ),
        );
      case LiveEventStatus.scheduled:
        return ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Vous serez notifié lorsque "${event.title}" sera en direct.',
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green[600],
              ),
            );
          },
          icon: const Icon(Icons.notifications_outlined, size: 18),
          label: const Text('Me notifier'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A3D4E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: StadiumBorder(),
            elevation: 0,
          ),
        );
      case LiveEventStatus.ended:
        return ElevatedButton.icon(
          onPressed: () => context.go('/live/${event.id}'),
          icon: const Icon(Icons.replay, size: 18),
          label: const Text('Regarder le replay'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A3D4E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: StadiumBorder(),
            elevation: 0,
          ),
        );
    }
  }

  String _relativeTimeText(LiveEvent event, DateTime now) {
    if (status == LiveEventStatus.scheduled) {
      final diff = event.startTime.difference(now);
      final hours = diff.inHours;
      final days = diff.inDays;
      if (diff.inMinutes <= 0) return 'Commence bientôt';
      if (hours < 24) {
        return 'Commence dans ${hours} h';
      } else if (days == 1) {
        final hourLabel = '${event.startTime.hour}';
        return 'Commence demain à ${hourLabel}h';
      } else {
        return 'Commence dans ${days} jours';
      }
    } else if (status == LiveEventStatus.ended) {
      final end = event.endTime ?? event.startTime;
      final diff = now.difference(end);
      final days = diff.inDays;
      if (diff.inHours < 24) {
        return 'Terminé il y a ${diff.inHours} heures';
      }
      return 'Terminé il y a ${days} jour${days > 1 ? 's' : ''}';
    }
    return '';
  }
}
