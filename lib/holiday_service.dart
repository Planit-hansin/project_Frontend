import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart'; // ⚠️ 밑의 설명 참고

class HolidayService {
  // ⭐️ 공공데이터포털에서 발급받은 'Decoding 인증키'
  final String apiKey = "e6096915850a619ad3924e56ca10f81e9ba4b07aee8acd91832b1c43c6b4bb56";

  Future<Map<String, String>> fetchHolidays(String year, String month) async {
    // 월을 항상 2자리(01, 05, 11 등) 형식으로 맞춰줍니다.
    final String formattedMonth = month.padLeft(2, '0');

    final String url = "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo?solYear=$year&solMonth=$formattedMonth&ServiceKey=$apiKey&_type=json";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // 공공데이터포털은 종종 완전한 JSON이 아닌 문자열로 줄 때가 있어 디코딩 처리를 합니다.
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        Map<String, String> holidaysMap = {}; // ⭐️ Map으로 변경

        final responseBody = data['response']['body'];
        if (responseBody['totalCount'] == 0) {
          return {}; // 공휴일이 없는 달 (예: 7월)
        }

        final items = responseBody['items']['item'];

        // 공휴일이 한 달에 여러 개일 때와 1개일 때 구조가 다르게 들어옵니다.
        if (items is List) {
          for (var item in items) {
            String locdate = item['locdate'].toString(); // 예: "20260505"
            String dateName = item['dateName'].toString();
            holidaysMap[locdate.substring(6)] = dateName;// 뒤의 "05" 일자만 추출
          }
        } else if (items is Map) {
          String locdate = items['locdate'].toString();
          String dateName = items['dateName'].toString();
          holidaysMap[locdate.substring(6)] = dateName;
        }

        return holidaysMap; // 공휴일 일자 리스트 반환 (예: ['05', '25'])
      }
    } catch (e) {
      print("공휴일 이름 로드 에러: $e");
    }
    return {};
  }
}