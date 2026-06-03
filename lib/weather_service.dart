import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {

  final String apiKey = "bec20073974d6360e0faeaaf3e04ad91"; //발급받은 실제 API 키

  // 위도(lat)와 경도(lon)를 받아 날씨 데이터를 Map 형태로 반환하는 함수
  Future<Map<String, dynamic>?> fetchWeather(double lat, double lon) async {
    final String url = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // 성공 시 JSON 파싱 데이터 반환
        return jsonDecode(response.body);
      } else {
        print("API 요청 실패 (코드: ${response.statusCode})");
        return null;
      }
    } catch (e) {
      print("네트워크 연결 에러: $e");
      return null;
    }
  }
}