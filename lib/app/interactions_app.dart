import 'package:flutter/material.dart';

import 'package:interactions/app/theme/app_theme.dart';
import 'package:interactions/home/home_screen.dart';

class InteractionsApp extends StatelessWidget {
  const InteractionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactions',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
