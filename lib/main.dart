import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ConverterApp());
}

class ConverterApp extends StatelessWidget {
  const ConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6B3C)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
