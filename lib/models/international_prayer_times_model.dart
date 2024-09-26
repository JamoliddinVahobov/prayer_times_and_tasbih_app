class InternationalPrayerTimes {
  final Timings timings;
  final HijriDate hijri;
  final GregorianDate gregorian;

  InternationalPrayerTimes(
      {required this.timings, required this.hijri, required this.gregorian});

  factory InternationalPrayerTimes.fromJson(Map<String, dynamic> json) {
    return InternationalPrayerTimes(
      timings: Timings.fromJson(json['data']['timings']),
      hijri: HijriDate.fromJson(json['data']['date']['hijri']),
      gregorian: GregorianDate.fromJson(json['data']['date']['gregorian']),
    );
  }
}

class Timings {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  Timings({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory Timings.fromJson(Map<String, dynamic> json) {
    return Timings(
      fajr: json['Fajr'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
    );
  }
}

class HijriDate {
  final String date;
  final String month;
  final String year;

  HijriDate({required this.date, required this.month, required this.year});

  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      date: json['date'],
      month: json['month']['en'], // or `json['month']['ar']` if you need Arabic
      year: json['year'],
    );
  }
}

class GregorianDate {
  final String date;
  final String month;
  final String year;

  GregorianDate({required this.date, required this.month, required this.year});

  factory GregorianDate.fromJson(Map<String, dynamic> json) {
    return GregorianDate(
      date: json['date'],
      month: json['month']['en'], // or `json['month']['ar']` if you need Arabic
      year: json['year'],
    );
  }
}
