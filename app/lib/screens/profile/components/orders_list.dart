part of '../profile_screen.dart';

class _OrdersList extends StatelessWidget {
  final String userId;

  const _OrdersList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OrdersBloc(api: MockApiService())..add(OrdersRequested(userId)),
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(color: Color(0xFF9D4EDD)),
              ),
            );
          }

          if (state.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  'Erreur : ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (state.orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  'Aucune commande pour le moment',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          final recentOrders = state.orders.take(3).toList();

          return Column(
            children: recentOrders
                .map((order) => _OrderTile(order: order))
                .toList(),
          );
        },
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final dynamic order;

  const _OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF9D4EDD).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getOrderIcon(order.status),
              color: const Color(0xFF9D4EDD),
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commande n°${order.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(order.createdAt),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${order.items.length} article${order.items.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(order.status),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.chevron_right,
            color: Colors.white.withValues(alpha: 0.3),
            size: 24,
          ),
        ],
      ),
    );
  }
}

IconData _getOrderIcon(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
    case 'delivered':
      return Icons.check_circle_outline;
    case 'pending':
    case 'processing':
      return Icons.access_time;
    case 'shipped':
      return Icons.local_shipping_outlined;
    case 'cancelled':
      return Icons.cancel_outlined;
    default:
      return Icons.shopping_bag_outlined;
  }
}

String _getStatusText(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return 'Livrée';
    case 'pending':
      return 'En attente';
    case 'shipped':
      return 'Expédiée';
    case 'processing':
      return 'En cours';
    case 'cancelled':
      return 'Annulée';
    default:
      return status;
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
    case 'delivered':
      return const Color(0xFF4ADE80);
    case 'pending':
    case 'processing':
      return const Color(0xFFFBBF24);
    case 'shipped':
      return const Color(0xFF60A5FA);
    case 'cancelled':
      return const Color(0xFFF87171);
    default:
      return const Color(0xFF9CA3AF);
  }
}

String _formatDate(DateTime date) {
  final months = [
    'janv.',
    'févr.',
    'mars',
    'avr.',
    'mai',
    'juin',
    'juil.',
    'août',
    'sept.',
    'oct.',
    'nov.',
    'déc.',
  ];
  return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
}
