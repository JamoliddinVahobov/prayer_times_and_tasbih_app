import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prayer_times_and_tasbih/change_mode/focus_color.dart';
import 'package:prayer_times_and_tasbih/models/international_prayer_times_model.dart';
import 'package:prayer_times_and_tasbih/models/uzbekistan_prayer_times_model.dart';
import 'package:prayer_times_and_tasbih/services/international_prayer_service.dart';
import 'package:prayer_times_and_tasbih/services/uzbekistan_prayer_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  PrayerTimesScreenState createState() => PrayerTimesScreenState();
}

class PrayerTimesScreenState extends State<PrayerTimesScreen> {
  String selectedOption = "O'zbekiston";
  String citySearch = "Qo'qon";
  InternationalPrayerTimes? internationalPrayerTimes;
  UzbPrayerTimes? uzbPrayerTimes;
  String errorMessage = '';
  TextEditingController cityController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final InternationalPrayerService internationalService =
      InternationalPrayerService();
  final UzbPrayerService uzbService = UzbPrayerService();

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes(citySearch);
    updateCityController();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  void updateCityController() {
    cityController.text = selectedOption == "O'zbekiston" ? "Qo'qon" : "Makka";
  }

  Timer? _errorTimer;

  @override
  void dispose() {
    _errorTimer?.cancel();
    _focusNode.dispose();
    cityController.dispose();
    super.dispose();
  }

  void setErrorMessageWithTimer(String message) {
    setState(() {
      errorMessage = message;
    });

    _errorTimer?.cancel();
    _errorTimer = Timer(const Duration(seconds: 7), () {
      if (mounted) {
        setState(() {
          errorMessage = '';
        });
      }
    });
  }

  Future<void> fetchPrayerTimes(String address) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Internet aloqasi mavjud emas")),
        );
      }
      return;
    }

    setState(() {
      errorMessage = '';
    });

    try {
      if (selectedOption == "O'zbekiston") {
        uzbPrayerTimes = await uzbService.fetchUzbPrayerTimes(address);
        if (uzbPrayerTimes == null) {
          setErrorMessageWithTimer(
              "Shahar topilmadi. Iltimos,Shahar nomini to'g'ri yozing");
          return;
        }
      } else {
        internationalPrayerTimes =
            await internationalService.fetchInternationalPrayerTimes(address);
        if (internationalPrayerTimes == null) {
          setErrorMessageWithTimer(
              "Shahar topilmadi. Iltimos,Shahar nomini to'g'ri yozing");
          return;
        }
      }
      if (mounted) {
        setState(() {
          errorMessage = '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void searchCity() {
    fetchPrayerTimes(citySearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: FittedBox(child: Text("Namoz Vaqtlari")),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.blue[700], // Use primary color for the refresh indicator
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: () async {
          await fetchPrayerTimes(citySearch);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 5, 18, 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  value: selectedOption,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, size: 30),
                  items: const [
                    DropdownMenuItem(
                      value: "O'zbekiston",
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "O'zbekiston",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Xalqaro",
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Xalqaro",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                      cityController.clear();
                      updateCityController();
                      citySearch =
                          selectedOption == "O'zbekiston" ? "Qo'qon" : "Makka";
                      fetchPrayerTimes(citySearch);
                    });
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: cityController,
                  focusNode: _focusNode, // Assign the focus node
                  decoration: InputDecoration(
                    labelText: "Shahar nomini kiriting",
                    hintText: selectedOption == "O'zbekiston"
                        ? "Masalan, Farg'ona"
                        : "Masalan, Madina",
                    prefixIcon: const Icon(Icons.location_city),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: searchCity,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    labelStyle: TextStyle(
                      color: _focusNode.hasFocus
                          ? context
                              .textFieldFocusBorderColor // Blue when focused
                          : context
                              .textFieldLabelColor, // Default color when not focused
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context
                            .textFieldBorderColor, // Use the extension for border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context
                            .textFieldFocusBorderColor, // Use the extension for focus border color
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context
                            .textFieldBorderColor, // Use the extension for enabled border color
                      ),
                    ),
                    errorText: errorMessage.isEmpty ? null : errorMessage,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  cursorColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    citySearch = value;
                  },
                  onSubmitted: (value) {
                    citySearch = value;
                    searchCity();
                  },
                ),
              ),
              const SizedBox(height: 12.0),
              Expanded(
                child: selectedOption == "O'zbekiston" && uzbPrayerTimes != null
                    ? ListView(
                        children: [
                          _buildPrayerTimeTile(
                              "Bomdod:", uzbPrayerTimes!.times.tongSaharlik),
                          _buildPrayerTimeTile(
                              "Quyosh:", uzbPrayerTimes!.times.quyosh),
                          _buildPrayerTimeTile(
                              "Peshin:", uzbPrayerTimes!.times.peshin),
                          _buildPrayerTimeTile(
                              "Asr:", uzbPrayerTimes!.times.asr),
                          _buildPrayerTimeTile(
                              "Shom:", uzbPrayerTimes!.times.shomIftor),
                          _buildPrayerTimeTile(
                              "Hufton:", uzbPrayerTimes!.times.hufton),
                          _buildPrayerTimeTile("Sana:", uzbPrayerTimes!.date),
                          _buildPrayerTimeTile(
                              "Hafta kuni:", uzbPrayerTimes!.weekday),
                          _buildPrayerTimeTile(
                            "Hijri Sana:",
                            "${uzbPrayerTimes!.hijriDate.month} ${uzbPrayerTimes!.hijriDate.day}",
                          ),
                        ],
                      )
                    : selectedOption == "Xalqaro" &&
                            internationalPrayerTimes != null
                        ? ListView(
                            children: [
                              _buildPrayerTimeTile("Bomdod:",
                                  internationalPrayerTimes!.timings.fajr),
                              _buildPrayerTimeTile("Peshin:",
                                  internationalPrayerTimes!.timings.dhuhr),
                              _buildPrayerTimeTile("Asr:",
                                  internationalPrayerTimes!.timings.asr),
                              _buildPrayerTimeTile("Shom:",
                                  internationalPrayerTimes!.timings.maghrib),
                              _buildPrayerTimeTile("Hufton:",
                                  internationalPrayerTimes!.timings.isha),
                              _buildPrayerTimeTile("Hijriy Sana:",
                                  internationalPrayerTimes!.hijri.date),
                              _buildPrayerTimeTile("Hijriy Oy:",
                                  internationalPrayerTimes!.hijri.month),
                              _buildPrayerTimeTile("Milodiy Sana:",
                                  internationalPrayerTimes!.gregorian.date),
                              _buildPrayerTimeTile("Milodiy Oy:",
                                  internationalPrayerTimes!.gregorian.month),
                            ],
                          )
                        : const Center(
                            child: SpinKitCircle(
                              color: Colors.green,
                              size: 60.0,
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimeTile(String title, String trailing) {
    const double fontSize = 17.0;
    const FontWeight fontWeight = FontWeight.w600;

    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
      trailing: Text(
        trailing,
        style: const TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }
}
