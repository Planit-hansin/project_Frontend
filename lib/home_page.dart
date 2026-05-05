import 'package:flutter/material.dart';
import 'ai_chat_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  // 나중에 가입 시 입력받은 이름을 저장할 변수입니다.
  final String userName = "민조";
  bool isExerciseDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildWeatherCard(),
              const SizedBox(height: 30),
              _buildHorizontalCalendar(),
              const SizedBox(height: 30),
              _buildScheduleBriefing(),
              const SizedBox(height: 30),
              _buildAIRoutineAnalysis(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          // 버튼 클릭 시 채팅 화면으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIChatPage()),
          );
        },
          backgroundColor: Colors.grey[300],
          shape: const CircleBorder(),
          child: const Text("AI", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
          )
    );
  }


  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "안녕하세요, $userName님!",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
  // 1. 오늘의 날씨 카드
  Widget _buildWeatherCard() {
    DateTime now = DateTime.now();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("오늘의 날씨", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              // _buildWeatherCard 내부의 날짜 텍스트 부분
              Text(
                "${now.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][now.month - 1]} ${now.year}",
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
              const SizedBox(height: 5),
              const Text("Cloudy", style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          Row(
            children: [
              const Text("18°C", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              Icon(Icons.cloud, size: 60, color: Colors.grey[300]),
            ],
          )
        ],
      ),
    );
  }

  // 2. 주간 달력
  Widget _buildHorizontalCalendar() {
    // 1) 오늘 날짜 정보 가져오기
    DateTime now = DateTime.now();

    // 2) 이번 주의 시작일(월요일) 계산하기
    // (오늘 날짜에서 현재 요일만큼 빼서 월요일로 이동)
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));

    // 3) 월요일부터 일요일까지 7일간의 데이터 생성
    final List<Map<String, dynamic>> days = List.generate(7, (index) {
      DateTime date = monday.add(Duration(days: index));

      // 요일 레이블 (Mo, Tu, Wed...)
      List<String> labels = ['Mo', 'Tu', 'Wed', 'Th', 'Fr', 'Sa', 'Su'];

      return {
        'day': date.day.toString(),
        'label': labels[index],
        // 실제 오늘 날짜(년, 월, 일)와 리스트의 날짜가 일치하는지 확인
        'selected': date.year == now.year &&
            date.month == now.month &&
            date.day == now.day,
      };
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((d) {
        final bool isSelected = d['selected'] == true;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFDECEC) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(
                d['day'] as String,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.redAccent : Colors.black,
                ),
              ),
              Text(
                d['label'] as String,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // 3. 일정 브리핑
  Widget _buildScheduleBriefing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("일정 브리핑", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 15),
        const Text("오늘은 일정이 없습니다.\n추천 일정을 등록하시겠어요?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF7357F2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.calendar_today, color: Colors.white),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("운동", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("19:00 - 20:00", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              // 2. 체크박스 역할을 하는 아이콘 버튼 추가
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExerciseDone = !isExerciseDone; // 클릭 시 상태 반전
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isExerciseDone ? Colors.greenAccent : Colors.transparent,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 10,
                    color: isExerciseDone ? Colors.white : Colors.transparent, // 체크 안 됐을 땐 투명하게
                  ),
                ),
              ),
              const SizedBox(width: 10), // 아이콘 사이 간격
              const Icon(Icons.add_circle, color: Colors.white),
            ],
          ),
        )
      ],
    );
  }
  // 4. AI 루틴 분석
  // 상단에 분석 결과를 담을 변수 선언 (나중에 API나 DB에서 받아온 값으로 교체)
  final String weeklyAnalysis = "일정 수행률 75% | 오전 집중도 높음";
  final String aiRecommendation = "중요한 업무는 오전 배치 권장\n주 2회 운동 → 3회로 늘려보세요!";

  Widget _buildAIRoutineAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("AI 루틴 분석", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBFA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column( // const 제거
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text("📊", style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Text("이번 주 분석", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 8),
              // 대화 및 일정 기반 분석 결과 반영
              Text(
                  weeklyAnalysis,
                  style: const TextStyle(color: Colors.black87, height: 1.3)
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text("💡", style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Text("AI 추천", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 8),
              // 사용자의 패턴(운동 횟수 등)을 분석한 맞춤 추천
              Text(
                  aiRecommendation,
                  style: const TextStyle(height: 1.4, color: Colors.black87)
              ),
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  // 하단 네비게이션 바
  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 100, 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home_filled, color: Colors.blueAccent),
          Icon(Icons.calendar_month_outlined, color: Colors.black54),
          Icon(Icons.list_alt, color: Colors.black54),
          Icon(Icons.settings_outlined, color: Colors.black54),
        ],
      ),
    );
  }
}
