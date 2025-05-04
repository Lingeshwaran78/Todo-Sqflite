import 'package:flutter/material.dart';
import 'package:notes/screens/home_screen.dart';
import 'package:root_jailbreak_sniffer/rjsniffer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool amICompromised = await Rjsniffer.amICompromised() ?? false;
  if (amICompromised) {
    runApp(const CompromisedDevice());
  } else {
    runApp(const MyApp());
  }
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

class CompromisedDevice extends StatelessWidget {
  const CompromisedDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/no_connection.png"),
              const Text("Sorry Your Device Compromised !"),
            ],
          ),
        ),
      ),
    );
  }
}
