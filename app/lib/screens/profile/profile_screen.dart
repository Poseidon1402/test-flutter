import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/order/orders_bloc.dart';
import '../../services/mock_api_service.dart';
part 'components/decorative_icon.dart';
part 'components/top_navigation_bar.dart';
part 'components/profile_header.dart';
part 'components/orders_list.dart';

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
                    "Vous n'êtes pas connecté",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9D4EDD),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Connexion'),
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
                      const _TopNavigationBar(),

                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 40),

                              // Profile Section
                              _ProfileHeader(user: user),

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
                                        'Historique des commandes',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Affichage des 3 commandes les plus récentes',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withValues(alpha: 0.6),
                                        ),
                                      ),
                                      const SizedBox(height: 24),

                                      // Orders List
                                      _OrdersList(userId: user.id),
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
                                  'Se déconnecter',
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
}
