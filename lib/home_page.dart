import 'package:flutter/material.dart';
import 'ai_chat_page.dart';
import 'calendar_page.dart';
import 'setting_page.dart';
import 'todo_page.dart';
import 'weather_service.dart';
import 'holiday_service.dart';

final HolidayService _holidayService = HolidayService();
Map<String, String> _currentMonthHolidays = {}; // 현재 달의 공휴일 일자 저장용

class HomePage extends StatefulWidget {
const HomePage({super.key});

@override
State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// 나중에 가입 시 입력받은 이름을 저장할 변수입니다.
final String userName = "민조";
int _selectedIndex = 0;
bool isExerciseDone = false;

final WeatherService _weatherService = WeatherService();
String _weatherCity = "로딩 중...";
String _weatherTemp = "--°C";
String _weatherMain = "Loading";

// 상단에 분석 결과를 담을 변수 선언
final String weeklyAnalysis = "일정 수행률 75% | 오전 집중도 높음";
final String aiRecommendation = "중요한 업무는 오전 배치 권장\n주 2회 운동 → 3회로 늘려보세요!";

Future<void> _loadWeather() async {
final data = await _weatherService.fetchWeather(37.5665, 126.9780); // 서울 위경도
if (data != null) {
setState(() {
_weatherCity = data['name'];
_weatherTemp = "${(data['main']['temp'] as num).toStringAsFixed(1)}°C";
_weatherMain = data['weather'][0]['main'];
});
} else {
setState(() {
_weatherCity = "날씨 로드 실패";
});
}
}

Future<void> _loadHolidays() async {
DateTime now = DateTime.now();
// 현재 년, 월의 공휴일을 불러옵니다.
final Map<String, String> holidays = await _holidayService.fetchHolidays(
now.year.toString(),
now.month.toString()
);
setState(() {
_currentMonthHolidays = holidays; // 예: ['05', '25']
});
}

@override
void initState() {
super.initState();
_loadWeather(); // 앱 실행 시 날씨 호출
_loadHolidays();
}

@override
Widget build(BuildContext context) {
Widget currentBody;
switch (_selectedIndex) {
case 0:
currentBody = _buildHomeContent();
break;
case 1:
currentBody = const CalendarPage();
break;
case 2:
currentBody = const TodoPage();
break;
case 3:
currentBody = const SettingPage();
break;
default:
currentBody = _buildHomeContent();
}

return Scaffold(
backgroundColor: Colors.white,
body: currentBody,
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
child: const Text("AI", style: TextStyle(
color: Colors.black54, fontWeight: FontWeight.bold)),
)
);
}

Widget _buildHomeContent() {
return SafeArea(
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

IconData getWeatherIcon(String main) {
switch (main.toLowerCase()) {
case 'clouds': return Icons.cloud;
case 'rain': return Icons.umbrella;
case 'clear': return Icons.wb_sunny;
case 'snow': return Icons.ac_unit;
default: return Icons.wb_cloudy;
}
}

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
Text(_weatherCity, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
Text(
"${now.day} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][now.month - 1]} ${now.year}",
style: TextStyle(color: Colors.grey[400], fontSize: 12),
),
const SizedBox(height: 5),
Text(_weatherMain, style: const TextStyle(fontWeight: FontWeight.w500)),
],
),
Row(
children: [
Text(_weatherTemp, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
const SizedBox(width: 10),
Icon(getWeatherIcon(_weatherMain), size: 55, color: Colors.blueGrey[200]),
],
)
],
),
);
}

// 2. 주간 달력 (오버플로우 해결 버전)
Widget _buildHorizontalCalendar() {
DateTime now = DateTime.now();
DateTime monday = now.subtract(Duration(days: now.weekday - 1));

final List<Map<String, dynamic>> days = List.generate(7, (index) {
DateTime date = monday.add(Duration(days: index));
List<String> labels = ['Mo', 'Tu', 'Wed', 'Th', 'Fr', 'Sa', 'Su'];
String dayStr = date.day.toString().padLeft(2, '0');
bool isHoliday = _currentMonthHolidays.containsKey(dayStr) || date.weekday == 7;

return {
'day': date.day.toString(),
'label': labels[index],
'selected': date.year == now.year && date.month == now.month && date.day == now.day,
'isHoliday': isHoliday,
};
});

return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: days.map((d) {
final bool isSelected = d['selected'] == true;
final bool isHoliday = d['isHoliday'] == true;

String dayStr = (d['day'] as String).padLeft(2, '0');
String? holidayName = _currentMonthHolidays[dayStr];

// 💡 Expanded로 감싸서 7개의 요일 탭이 화면 너비를 초과하지 않고 기기에 맞춰 정등분되도록 설계
return Expanded(
child: Container(
padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
decoration: BoxDecoration(
color: isSelected ? const Color(0xFFFDECEC) : Colors.transparent,
borderRadius: BorderRadius.circular(15),
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Text(
d['day'] as String,
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: isSelected
? Colors.redAccent
    : (isHoliday ? Colors.red : Colors.black),
),
),
Text(
d['label'] as String,
style: TextStyle(fontSize: 11, color: isHoliday ? Colors.red[300] : Colors.grey[400]),
),
if (holidayName != null)
Padding(
padding: const EdgeInsets.only(top: 4.0),
child: Text(
holidayName,
textAlign: TextAlign.center,
maxLines: 1,
overflow: TextOverflow.ellipsis, // 글자가 긴 경우 잘림 방지(...)
style: const TextStyle(
fontSize: 8,
color: Colors.redAccent,
fontWeight: FontWeight.bold
),
),
),
],
),
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
const Text("일정 브리핑",
style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
const SizedBox(height: 15),
const Text("오늘은 일정이 없습니다.\n추천 일정을 등록하시겠어요?",
style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
decoration: BoxDecoration(color: Colors.white24,
borderRadius: BorderRadius.circular(10)),
child: const Icon(Icons.calendar_today, color: Colors.white),
),
const SizedBox(width: 15),
const Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text("운동", style: TextStyle(
color: Colors.white, fontWeight: FontWeight.bold)),
Text("19:00 - 20:00",
style: TextStyle(color: Colors.white70, fontSize: 12)),
],
),
),
GestureDetector(
behavior: HitTestBehavior.opaque,
onTap: () {
setState(() {
isExerciseDone = !isExerciseDone;
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
color: isExerciseDone ? Colors.white : Colors.transparent,
),
),
),
const SizedBox(width: 10),
const Icon(Icons.add_circle, color: Colors.white),
],
),
)
],
);
}

// 4. AI 루틴 분석 (렉 및 오버플로우 완전 해결 버전)
Widget _buildAIRoutineAnalysis() {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text("AI 루틴 분석",
style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
const SizedBox(height: 15),
Container(
width: double.infinity,
padding: const EdgeInsets.all(22),
decoration: BoxDecoration(
color: const Color(0xFFEBEBFA),
borderRadius: BorderRadius.circular(20),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisSize: MainAxisSize.min, // 💡 불필요하게 영역을 무한 확장하려는 버그 방지
children: [
Row(
children: [
const Text("📊", style: TextStyle(fontSize: 18)),
const SizedBox(width: 8),
Expanded(
child: Text("이번 주 분석", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
),
],
),
const SizedBox(height: 8),
// 💡 렉을 일으키던 Flexible을 제거하고 무조건 줄바꿈 텍스트 배치
Text(
weeklyAnalysis,
style: const TextStyle(color: Colors.black87, height: 1.3)
),
const SizedBox(height: 20),
Row(
children: [
const Text("💡", style: TextStyle(fontSize: 18)),
const SizedBox(width: 8),
Expanded(
child: Text("AI 추천", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
),
],
),
const SizedBox(height: 8),
// 💡 렉을 일으키던 Flexible을 제거하고 무조건 줄바꿈 텍스트 배치
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
return Padding(
padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
child: Container(
padding: const EdgeInsets.symmetric(vertical: 10),
decoration: BoxDecoration(
color: const Color(0xFFF1F3F5),
borderRadius: BorderRadius.circular(30),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.05),
blurRadius: 10,
offset: const Offset(0, 5),
),
],
),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
IconButton(
icon: Icon(Icons.home_filled,
color: _selectedIndex == 0 ? Colors.blueAccent : Colors.black54),
onPressed: () => setState(() => _selectedIndex = 0),
),
IconButton(
icon: Icon(Icons.calendar_month_outlined,
color: _selectedIndex == 1 ? Colors.blueAccent : Colors.black54),
onPressed: () => setState(() => _selectedIndex = 1),
),
IconButton(
icon: Icon(Icons.list_alt,
color: _selectedIndex == 2 ? Colors.blueAccent : Colors.black54),
onPressed: () => setState(() => _selectedIndex = 2),
),
IconButton(
icon: Icon(Icons.settings_outlined,
color: _selectedIndex == 3 ? Colors.blueAccent : Colors.black54),
onPressed: () => setState(() => _selectedIndex = 3),
),
],
),
),
);
}
}