import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart'; // 이동할 페이지 임포트

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // 3초 후에 홈 화면으로 이동
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 (브랜드 컬러로 변경 가능)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. 가운데 로고 (이미지가 없다면 아이콘이나 텍스트로 대체)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF7357F2), // PtoJ 포인트 컬러
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.event_available,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "PtoJ",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const Text(
              "AI Scheduler APP ",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            // 2. 하단 여백 확보 후 로딩 인디케이터
            const SizedBox(height: 100),
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7357F2)),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}