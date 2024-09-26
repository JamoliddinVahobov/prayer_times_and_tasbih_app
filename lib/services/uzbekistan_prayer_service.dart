import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/uzbekistan_prayer_times_model.dart';

class UzbPrayerService {
  Future<UzbPrayerTimes?> fetchUzbPrayerTimes(String city) async {
    try {
      final response = await http
          .get(Uri.parse("https://islomapi.uz/api/present/day?region=$city"));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return UzbPrayerTimes.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null; // City not found
      } else {
        throw Exception("An error occurred while loading prayer times");
      }
    } catch (e) {
      return null;
    }
  }
}
