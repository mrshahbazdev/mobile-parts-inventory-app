import 'package:flutter/material.dart';
import 'package:mobile_parts_app/theme/app_theme.dart';
import 'package:mobile_parts_app/screens/home_screen.dart';

class MobilePartsApp extends StatelessWidget {
  const MobilePartsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Parts App',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
