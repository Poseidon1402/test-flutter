import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter/blocs/live_event/live_event_bloc.dart';

import 'config/theme_config.dart';
import 'services/mock_api_service.dart';
import 'services/mock_socket_service.dart';
import 'blocs/live_events/live_events_bloc.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'app_router.dart';

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final api = MockApiService();
    final socket = MockSocketService();

    final appRouter = AppRouter(
      onToggleTheme: _toggleTheme,
      themeMode: _themeMode,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LiveEventsBloc(api)..add(const LiveEventsRequested()),
        ),
        BlocProvider(
          create: (_) => LiveEventBloc(api: api, socket: socket),
        ),
        BlocProvider(
          create: (_) => CartBloc(api: api)..add(const CartRequested()),
        ),
        BlocProvider(
          create: (_) => AuthBloc(api: api)..add(const AuthStarted()),
        ),
        // Other BLoCs (LiveEventBloc, ChatBloc) will be provided closer to their screens
      ],
      child: MaterialApp.router(
        title: 'Live Shopping',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _themeMode,
        routerConfig: appRouter.router,
      ),
    );
  }
}
