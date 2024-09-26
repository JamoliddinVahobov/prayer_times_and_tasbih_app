class UzbPrayerTimes {
  final String region;
  final String date;
  final String weekday;
  final HijriDateOfUzbApi hijriDate;
  final UzbTimes times;

  UzbPrayerTimes(
      {required this.region,
      required this.date,
      required this.weekday,
      required this.hijriDate,
      required this.times});

  factory UzbPrayerTimes.fromJson(Map<String, dynamic> json) {
    return UzbPrayerTimes(
      region: json['region'],
      date: json['date'],
      weekday: json['weekday'],
      hijriDate: HijriDateOfUzbApi.fromJson(json['hijri_date']),
      times: UzbTimes.fromJson(json['times']),
    );
  }
}

class HijriDateOfUzbApi {
  final String month;
  final int day;

  HijriDateOfUzbApi({required this.month, required this.day});

  factory HijriDateOfUzbApi.fromJson(Map<String, dynamic> json) {
    return HijriDateOfUzbApi(
      month: json['month'],
      day: json['day'],
    );
  }
}

class UzbTimes {
  final String tongSaharlik;
  final String quyosh;
  final String peshin;
  final String asr;
  final String shomIftor;
  final String hufton;

  UzbTimes(
      {required this.tongSaharlik,
      required this.quyosh,
      required this.peshin,
      required this.asr,
      required this.shomIftor,
      required this.hufton});

  factory UzbTimes.fromJson(Map<String, dynamic> json) {
    return UzbTimes(
      tongSaharlik: json['tong_saharlik'],
      quyosh: json['quyosh'],
      peshin: json['peshin'],
      asr: json['asr'],
      shomIftor: json['shom_iftor'],
      hufton: json['hufton'],
    );
  }
}
