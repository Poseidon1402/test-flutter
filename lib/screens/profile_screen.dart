import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc.dart';
import '../blocs/orders_bloc.dart';
import '../services/mock_api_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState.status != AuthStatus.authenticated || authState.user == null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('You are not logged in'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/login');
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                );
              }

              final user = authState.user!;

              return BlocProvider(
                create: (_) => OrdersBloc(api: MockApiService())
                  ..add(OrdersRequested(user.id)),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 800;
                    final content = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(user.email),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<AuthBloc>().add(const LogoutRequested());
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text('Logout'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Order history',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: BlocBuilder<OrdersBloc, OrdersState>(
                            builder: (context, state) {
                              if (state.isLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (state.error != null) {
                                return Center(child: Text('Error: ${state.error}'));
                              }
                              if (state.orders.isEmpty) {
                                return const Center(child: Text('No orders yet'));
                              }

                              return Scrollbar(
                                child: ListView.builder(
                                  itemCount: state.orders.length,
                                  itemBuilder: (context, index) {
                                    final order = state.orders[index];
                                    final itemsSummary = order.items
                                        .map((i) => '${i.quantity}x ${i.name}')
                                        .join(', ');
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Order ${order.id}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                ),
                                                Text(
                                                  order.status.toUpperCase(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${order.createdAt.toLocal()}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              itemsSummary,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            const SizedBox(height: 8),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                '${order.total.toStringAsFixed(2)} €',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );

                    if (isWide) {
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: content,
                        ),
                      );
                    }
                    return content;
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
