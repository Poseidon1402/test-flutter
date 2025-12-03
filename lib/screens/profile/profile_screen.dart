import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth_bloc.dart';
import '../../blocs/orders_bloc.dart';
import '../../services/mock_api_service.dart';

// Content moved from lib/screens/profile_screen.dart
// (unchanged UI; only import paths adjusted)

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState.status != AuthStatus.authenticated ||
            authState.user == null) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A1D2E),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'You are not logged in',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D4EDD),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          );
        }

        final user = authState.user!;

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F1729),
                  Color(0xFF1A1D2E),
                  Color(0xFF2D1B4E),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Decorative background elements
                Positioned(
                  top: size.height * 0.15,
                  left: size.width * 0.08,
                  child: _DecorativeIcon(
                    icon: Icons.shopping_bag_outlined,
                    rotation: -0.2,
                    opacity: 0.03,
                    size: 120,
                  ),
                ),
                Positioned(
                  bottom: size.height * 0.25,
                  right: size.width * 0.1,
                  child: _DecorativeIcon(
                    icon: Icons.card_giftcard_outlined,
                    rotation: 0.15,
                    opacity: 0.03,
                    size: 140,
                  ),
                ),

                // Main content
                SafeArea(
                  child: Column(
                    children: [
                      // Top Navigation Bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            // LiveShop Logo
                            InkWell(
                              onTap: () => context.go('/'),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF9D4EDD),
                                          Color(0xFF7B2CBF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.shopping_bag,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'LiveShop',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),

                            // Navigation Links
                            TextButton(
                              onPressed: () => context.go('/'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Home',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {}, // Already on My Orders
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF9D4EDD),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'My Orders',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // User Avatar
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF9D4EDD),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  'https://picsum.photos/200/200',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(
                                        0xFF9D4EDD,
                                      ).withOpacity(0.2),
                                      child: const Icon(
                                        Icons.person,
                                        color: Color(0xFF9D4EDD),
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 40),

                              // Profile Section
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF9D4EDD),
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF9D4EDD,
                                      ).withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    'https://picsum.photos/200/200',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color(0xFF2A2D3E),
                                        child: const Icon(
                                          Icons.person,
                                          color: Color(0xFF9D4EDD),
                                          size: 60,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // User Name
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // User Email
                              Text(
                                user.email,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),

                              const SizedBox(height: 60),

                              // Order History Section
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 800,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Order History',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Showing 3 most recent orders',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                      const SizedBox(height: 24),

                                      // Orders List
                                      BlocProvider(
                                        create: (_) =>
                                            OrdersBloc(api: MockApiService())
                                              ..add(OrdersRequested(user.id)),
                                        child: BlocBuilder<OrdersBloc, OrdersState>(
                                          builder: (context, state) {
                                            if (state.isLoading) {
                                              return const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(40),
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Color(
                                                          0xFF9D4EDD,
                                                        ),
                                                      ),
                                                ),
                                              );
                                            }

                                            if (state.error != null) {
                                              return Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    40,
                                                  ),
                                                  child: Text(
                                                    'Error: ${state.error}',
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }

                                            if (state.orders.isEmpty) {
                                              return Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    40,
                                                  ),
                                                  child: Text(
                                                    'No orders yet',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }

                                            final recentOrders = state.orders
                                                .take(3)
                                                .toList();

                                            return Column(
                                              children: recentOrders.map((
                                                order,
                                              ) {
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                    bottom: 16,
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                    24,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFF2A2D3E,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.white
                                                          .withOpacity(0.1),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      // Order Icon
                                                      Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                          color: const Color(
                                                            0xFF9D4EDD,
                                                          ).withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        child: Icon(
                                                          _getOrderIcon(
                                                            order.status,
                                                          ),
                                                          color: const Color(
                                                            0xFF9D4EDD,
                                                          ),
                                                          size: 24,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 20),

                                                      // Order Details
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Order #${order.id}',
                                                              style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              _formatDate(
                                                                order.createdAt,
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                      0.5,
                                                                    ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            Text(
                                                              '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                      0.7,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Price and Status
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            '\$${order.total.toStringAsFixed(2)}',
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  _getStatusColor(
                                                                    order
                                                                        .status,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    20,
                                                                  ),
                                                            ),
                                                            child: Text(
                                                              _getStatusText(
                                                                order.status,
                                                              ),
                                                              style: const TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(width: 16),
                                                      Icon(
                                                        Icons.chevron_right,
                                                        color: Colors.white
                                                            .withOpacity(0.3),
                                                        size: 24,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 60),

                              // Logout Button
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                    const LogoutRequested(),
                                  );
                                  context.go('/');
                                },
                                icon: const Icon(Icons.logout, size: 20),
                                label: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color(0xFF9D4EDD),
                                    width: 2,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                              ),

                              const SizedBox(height: 60),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
        return 'Delivered';
      case 'pending':
        return 'Pending';
      case 'shipped':
        return 'Shipped';
      case 'processing':
        return 'Processing';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return const Color(0xFF4ADE80); // Green
      case 'pending':
      case 'processing':
        return const Color(0xFFFBBF24); // Yellow
      case 'shipped':
        return const Color(0xFF60A5FA); // Blue
      case 'cancelled':
        return const Color(0xFFF87171); // Red
      default:
        return const Color(0xFF9CA3AF); // Gray
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }
}

class _DecorativeIcon extends StatelessWidget {
  final IconData icon;
  final double rotation;
  final double opacity;
  final double size;

  const _DecorativeIcon({
    required this.icon,
    required this.rotation,
    required this.opacity,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Icon(icon, size: size, color: Colors.white.withOpacity(opacity)),
    );
  }
}
