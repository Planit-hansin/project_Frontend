import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
const TodoPage({super.key});

@override
State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
// 사용자가 각 항목을 직접 수정할 수 있도록 6개의 텍스트 컨트롤러 생성
late List<TextEditingController> _controllers;

// 체크박스 상태 리스트
final List<bool> _isItemDone = List.generate(6, (index) => true);

@override
void initState() {
super.initState();
_controllers = List.generate(
6,
(index) => TextEditingController(text: "투두리스트 ${index + 1}"),
);
}

@override
void dispose() {
for (var controller in _controllers) {
controller.dispose();
}
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFFAFAFA),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

_buildCleanYearMonthHeader(),
const SizedBox(height: 24),

_buildHorizontalCalendar(),
const SizedBox(height: 35),

const Text(
"To-Do",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.w800,
color: Color(0xFF1A1A1A),
letterSpacing: -0.5,
),
),
const SizedBox(height: 16),


_buildMainContentBox(),
const SizedBox(height: 50),
],
),
),
),
);
}


Widget _buildCleanYearMonthHeader() {
DateTime now = DateTime.now();

return Padding(
padding: const EdgeInsets.symmetric(vertical: 4.0),
child: Row(
crossAxisAlignment: CrossAxisAlignment.baseline,
textBaseline: TextBaseline.alphabetic,
children: [
Text(
"${now.year}년 ",
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.w800,
color: Color(0xFF1A1A1A),
letterSpacing: -1.0,
),
),
Text(
"${now.month}월",
style: const TextStyle(
fontSize: 24,
fontWeight: FontWeight.w400,
color: Color(0xFF555555),
letterSpacing: -1.0,
),
),
],
),
);
}

// 💡 2. 트렌디한 무드로 다듬은 주간 달력
Widget _buildHorizontalCalendar() {
DateTime now = DateTime.now();
DateTime monday = now.subtract(Duration(days: now.weekday - 1));

final List<Map<String, dynamic>> days = List.generate(7, (index) {
DateTime date = monday.add(Duration(days: index));
List<String> labels = ['Mo', 'Tu', 'Wed', 'Th', 'Fr', 'Sa', 'Su'];

return {
'day': date.day.toString(),
'label': labels[index],
'selected': date.year == now.year && date.month == now.month && date.day == now.day,
'isSunday': date.weekday == 7,
};
});

return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: days.map((d) {
final bool isSelected = d['selected'] == true;
final bool isSunday = d['isSunday'] == true;

return Expanded(
child: Container(
margin: const EdgeInsets.symmetric(horizontal: 4.0),
padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
decoration: BoxDecoration(
// 💡 오늘 날짜는 차분하고 세련된 소프트 핑크 라운드 배경 처리
color: isSelected ? const Color(0xFFFEECEB) : Colors.transparent,
borderRadius: BorderRadius.circular(12),
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Text(
d['day'] as String,
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.w700,
color: isSelected
? const Color(0xFFE05353)
    : (isSunday ? Colors.red.shade400 : const Color(0xFF2D3142)),
),
),
const SizedBox(height: 6),
Text(
d['label'] as String,
style: TextStyle(
fontSize: 11,
fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
color: isSelected
? const Color(0xFFE05353)
    : (isSunday ? Colors.red.shade300 : const Color(0xFF9CA3AF)),
),
),
],
),
),
);
}).toList(),
);
}


Widget _buildMainContentBox() {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(24),

boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.03),
blurRadius: 15,
offset: const Offset(0, 8),
),
],
),
child: Column(
children: List.generate(6, (index) {
return Column(
children: [
_buildEditableTodoItem(index),
if (index < 5) const SizedBox(height: 10),
],
);
}),
),
);
}


Widget _buildEditableTodoItem(int index) {
return Container(
width: double.infinity,
height: 60,
padding: const EdgeInsets.symmetric(horizontal: 16),
decoration: BoxDecoration(
color: const Color(0xFFF6F5FF),
borderRadius: BorderRadius.circular(16),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Expanded(
child: TextField(
controller: _controllers[index],
cursorColor: const Color(0xFF6B50F6),
decoration: const InputDecoration(
border: InputBorder.none,
contentPadding: EdgeInsets.zero,
),
style: const TextStyle(
fontSize: 14,
fontWeight: FontWeight.w600,
color: Color(0xFF2D3142),
),
),
),
const SizedBox(width: 10),


GestureDetector(
onTap: () {
setState(() {
_isItemDone[index] = !_isItemDone[index];
});
},
child: Container(
width: 24,
height: 24,
decoration: BoxDecoration(
color: _isItemDone[index] ? const Color(0xFF6B50F6) : Colors.transparent,
borderRadius: BorderRadius.circular(8), // 약간 더 라운딩된 사각형
border: Border.all(
color: const Color(0xFF6B50F6),
width: 1.5,
),
),
child: _isItemDone[index]
? const Icon(
Icons.check_rounded,
color: Colors.white,
size: 16,
)
    : null,
),
),
],
),
);
}
}