import 'package:flutter/material.dart';
import 'add_schedule_page.dart';
import 'holiday_service.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();

  // ⭐️ 아래 2줄 추가
  final HolidayService _holidayService = HolidayService();
  Map<String, String> _currentMonthHolidays = {}; // 서버에서 받아온 공휴일 '일' 리스트

  // 테스트용 일정 데이터
  final Map<String, List<String>> _schedules = {
    "2026-05-12": ["캡스톤 디자인 회의", "Flutter 코드 수정"],
  };
// ⭐️ 공휴일 데이터를 비동기로 가져오는 함수 추가
  Future<void> _loadHolidays(int year, int month) async {
    final holidays = await _holidayService.fetchHolidays(
      year.toString(),
      month.toString(),
    );
    setState(() {
      _currentMonthHolidays = holidays; // 예: ['05', '25']
    });
  }

  @override
  void initState() {
    super.initState();
    // ⭐️ 초기화 시 현재 날짜 기준 공휴일 로드
    _loadHolidays(_selectedDay.year, _selectedDay.month);
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDay) {
      setState(() => _selectedDay = picked);
      _loadHolidays(picked.year, picked.month);
    }
  }

  @override
  Widget build(BuildContext context) {
    int year = _selectedDay.year;
    int month = _selectedDay.month;
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    int daysInMonth = DateTime(year, month + 1, 0).day;
    int firstWeekday = firstDayOfMonth.weekday % 7;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: GestureDetector(
          onTap: () => _selectDate(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("$year/${month.toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_circle_right_outlined, color: Colors.black),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _buildWeekdayHeader(),
          const Divider(height: 1, thickness: 1, color: Colors.black),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 0.6,
              ),
              itemCount: firstWeekday + daysInMonth,
              itemBuilder: (context, index) {
                if (index < firstWeekday) return Container(decoration: _boxDecor());

                int day = index - firstWeekday + 1;

                String dayStr = day.toString().padLeft(2, '0');
                String? holidayName = _currentMonthHolidays[dayStr];
                bool isHoliday = holidayName != null;

                bool isRedDay = (index % 7 == 0 || isHoliday);
                bool isSaturday = (index % 7 == 6);
                bool isSelected = (day == _selectedDay.day && month == _selectedDay.month && year == _selectedDay.year);

                String loopDateKey = "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
                List<String> loopSchedules = _schedules[loopDateKey] ?? [];

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedDay = DateTime(year, month, day));
                    _showScheduleModal(context, loopSchedules);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            "$day",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isRedDay
                                  ? Colors.red
                                  : (isSaturday ? Colors.blue : Colors.black),
                            ),
                          ),
                        ),

                        if (isHoliday)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE8E6), // 연한 빨간 배경
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                holidayName, // 예: "어린이날"
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        if (loopSchedules.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F0FE),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                loopSchedules[0],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        if (loopSchedules.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0, top: 2),
                            child: Text(
                              "+${loopSchedules.length - 1}",
                              style: const TextStyle(fontSize: 9, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showScheduleModal(BuildContext context, List<String> daySchedules) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F4F9),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${_selectedDay.month}월 ${_selectedDay.day}일 (${_getWeekday(_selectedDay)})",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  daySchedules.isEmpty
                      ? const Center(
                      child: Text("오늘은 등록된 일정이 없습니다.", style: TextStyle(color: Colors.grey, fontSize: 16)))
                      : Expanded(
                    child: ListView.builder(
                      itemCount: daySchedules.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: const Icon(Icons.circle, size: 10, color: Colors.blueAccent),
                          title: Text(daySchedules[index], style: const TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddSchedulePage()));
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC0D3F8),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
                  ),
                  child: const Icon(Icons.add, color: Colors.blueAccent, size: 40),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeekdayHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildWeekdayText("Sun", Colors.red),
          _buildWeekdayText("Mon", Colors.black),
          _buildWeekdayText("Tue", Colors.black),
          _buildWeekdayText("Wed", Colors.black),
          _buildWeekdayText("Thu", Colors.black),
          _buildWeekdayText("Fri", Colors.black),
          _buildWeekdayText("Sat", Colors.blue),
        ],
      ),
    );
  }

  Widget _buildWeekdayText(String label, Color color) {
    return Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16));
  }

  String _getWeekday(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[date.weekday - 1];
  }

  BoxDecoration _boxDecor() => BoxDecoration(border: Border.all(color: Colors.grey.shade300, width: 1.0));
}