import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';

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
              builder: (context, state) => HomeScreen(
                onToggleTheme: onToggleTheme,
                themeMode: themeMode,
              ),
            ),
            // TODO: add routes for live event, cart, checkout, profile
          ],
        );

  final GoRouter _router;

  GoRouter get router => _router;
}
