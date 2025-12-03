import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/live_event/live_event_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/product_detail_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter({required VoidCallback onToggleTheme, required ThemeMode themeMode})
    : _router = GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) =>
                HomeScreen(onToggleTheme: onToggleTheme, themeMode: themeMode),
          ),
          GoRoute(
            path: '/cart',
            name: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/checkout',
            name: 'checkout',
            builder: (context, state) => const CheckoutScreen(),
          ),
          GoRoute(
            path: '/live/:id',
            name: 'live-event',
            builder: (context, state) {
              final eventId = state.pathParameters['id']!;
              return LiveEventScreen(eventId: eventId);
            },
          ),
          GoRoute(
            path: '/login',
            name: 'login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/product/:id',
            name: 'product-detail',
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              return ProductDetailScreen(productId: productId);
            },
          ),
        ],
      );

  final GoRouter _router;

  GoRouter get router => _router;
}
