import 'package:flutter/material.dart';
import 'loading_page.dart';

void main() {
  runApp(const PlanitApp());
}

class PlanitApp extends StatelessWidget {
  const PlanitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PtoJ Scheduler',
      theme: ThemeData(primarySwatch: Colors.indigo),
      // 홈 화면 대신 로딩 화면을 첫 페이지로 설정
      home: const LoadingPage(),
    );
  }
}