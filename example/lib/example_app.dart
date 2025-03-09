import 'package:example/menu_screen.dart';
import 'package:flutter/material.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterTBS Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const ExampleMenuScreen(),
    );
  }
}
