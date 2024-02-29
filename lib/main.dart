import 'package:flutter/material.dart';
import 'package:todo_sqflite/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blueGrey.shade900,
        appBarTheme: const AppBarTheme(color: Colors.transparent, elevation: 0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const HomePage(),
    );
  }
}
