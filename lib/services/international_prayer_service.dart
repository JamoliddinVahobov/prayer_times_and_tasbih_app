import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prayer_times_and_tasbih/models/international_prayer_times_model.dart';

class InternationalPrayerService {
  Future<InternationalPrayerTimes?> fetchInternationalPrayerTimes(
      String address) async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.aladhan.com/v1/timingsByAddress/present?address=$address"));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['code'] == 200) {
          return InternationalPrayerTimes.fromJson(jsonData);
        } else {
          return null; // City not found
        }
      } else if (response.statusCode == 404) {
        return null; // City not found
      } else {
        throw Exception("Namoz vaqtlarini yuklashda xatolik yuz berdi");
      }
    } catch (e) {
      return null;
    }
  }
}
