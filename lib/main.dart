import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const PlanitApp());
}

class PlanitApp extends StatelessWidget {
  const PlanitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(), // 👈 home_page.dart에 정의된 클래스 이름
    );
  }
}