import 'package:flutter/material.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final TextEditingController _titleController = TextEditingController();

  // 기능 데이터 변수
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 41);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 41);

  // 날짜 선택 함수
  Future<void> _pickDate(bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked; else _endDate = picked;
      });
    }
  }

  // 시간 선택 함수
  Future<void> _pickTime(bool isStart) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startTime = picked; else _endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. 헤더 영역 (캡처 디자인 반영)
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 40, 25, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_border, size: 35, color: Colors.black),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: "제목",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1.5, color: Colors.black),
                ],
              ),
            ),
            // 2. 입력 폼 (스크롤 가능 영역)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // 시작 & 종료 시간 설정 (회색 큰 박스)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Column(
                        children: [
                          _buildTimePickerRow("시작", _startDate, _startTime, true),
                          const SizedBox(height: 20),
                          _buildTimePickerRow("종료", _endDate, _endTime, false),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),
                    _buildCapsuleRow(icon: Icons.notifications_none, label: "10분전"),
                    const SizedBox(height: 15),
                    _buildCapsuleRow(icon: Icons.location_on_outlined, label: "장소"),
                    const SizedBox(height: 15),
                    _buildCapsuleRow(icon: Icons.sticky_note_2_outlined, label: "메모", hasArrow: true),
                    const SizedBox(height: 15),

                    // 라벨 영역
                    _buildCapsuleRow(
                      icon: Icons.label_outline,
                      label: "Label",
                      hasArrow: true,
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. 하단 버튼 영역
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 결과값을 들고 돌아감
                        Navigator.pop(context, {
                          'title': _titleController.text,
                          'date': "${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}"
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A64CC),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 날짜와 시간을 누를 수 있는 행 위젯
  Widget _buildTimePickerRow(String label, DateTime date, TimeOfDay time, bool isStart) {
    return Row(
      children: [
        SizedBox(width: 40, child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
        const SizedBox(width: 10),
        // 날짜 칩
        GestureDetector(
          onTap: () => _pickDate(isStart),
          child: _buildChip("${_getMonthName(date.month)} ${date.day}, ${date.year}"),
        ),
        const SizedBox(width: 10),
        // 시간 칩
        GestureDetector(
          onTap: () => _pickTime(isStart),
          child: _buildChip(time.format(context)),
        ),
      ],
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  // 둥근 캡슐형 행 위젯
  Widget _buildCapsuleRow({required IconData icon, required String label, bool hasArrow = false, Widget? trailing}) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(width: 15),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          if (trailing != null) trailing,
          if (hasArrow) const Icon(Icons.chevron_right, color: Colors.black),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }
}