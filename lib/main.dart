import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/theme_config.dart';
import 'services/mock_api_service.dart';
import 'blocs/live_events_bloc.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = MockApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LiveEventsBloc(api)..add(const LiveEventsRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Live Shopping',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomeScreen(),
      ),
    );
  }
}
