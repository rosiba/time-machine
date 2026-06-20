import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/logs_provider.dart';
import 'providers/projects_provider.dart';
import 'providers/timer_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TimeMachineApp());
}

class TimeMachineApp extends StatelessWidget {
  const TimeMachineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectsProvider()..load()),
        ChangeNotifierProvider(create: (_) => LogsProvider()..load()),
        ChangeNotifierProxyProvider<LogsProvider, TimerProvider>(
          create: (_) => TimerProvider(),
          update: (_, logs, timer) => timer!..setLogsProvider(logs),
        ),
      ],
      child: MaterialApp(
        title: 'Time Machine',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: _theme(Brightness.light),
        darkTheme: _theme(Brightness.dark),
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData _theme(Brightness brightness) => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: brightness,
        ),
        useMaterial3: true,
      );
}
