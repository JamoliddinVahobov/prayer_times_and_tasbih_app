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
  String selectedOption = "Uzbekistan";
  String citySearch = "Toshkent";
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
    cityController.text = selectedOption == "Uzbekistan" ? "Toshkent" : "Mecca";
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
          const SnackBar(content: Text("No internet connection")),
        );
      }
      return;
    }

    setState(() {
      errorMessage = '';
    });

    try {
      if (selectedOption == "Uzbekistan") {
        uzbPrayerTimes = await uzbService.fetchUzbPrayerTimes(address);
        if (uzbPrayerTimes == null) {
          setErrorMessageWithTimer(
              "City not found. Please enter the correct city name");
          return;
        }
      } else {
        internationalPrayerTimes =
            await internationalService.fetchInternationalPrayerTimes(address);
        if (internationalPrayerTimes == null) {
          setErrorMessageWithTimer(
              "City not found. Please enter the correct city name");
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
          child: FittedBox(child: Text("Prayer Times")),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.blue[700],
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
                      value: "Uzbekistan",
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Uzbekistan",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "International",
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "International",
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
                          selectedOption == "Uzbekistan" ? "Toshkent" : "Mecca";
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
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: "Enter city name",
                    hintText: selectedOption == "Uzbekistan"
                        ? "For example, Fergana"
                        : "For example, Medina",
                    prefixIcon: const Icon(Icons.location_city),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: searchCity,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    labelStyle: TextStyle(
                      color: _focusNode.hasFocus
                          ? context.textFieldFocusBorderColor
                          : context.textFieldLabelColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.textFieldBorderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.textFieldFocusBorderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.textFieldBorderColor,
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
                child: selectedOption == "Uzbekistan" && uzbPrayerTimes != null
                    ? ListView(
                        children: [
                          _buildPrayerTimeTile(
                              "Fajr:", uzbPrayerTimes!.times.tongSaharlik),
                          _buildPrayerTimeTile(
                              "Sunrise:", uzbPrayerTimes!.times.quyosh),
                          _buildPrayerTimeTile(
                              "Dhuhr:", uzbPrayerTimes!.times.peshin),
                          _buildPrayerTimeTile(
                              "Asr:", uzbPrayerTimes!.times.asr),
                          _buildPrayerTimeTile(
                              "Maghrib:", uzbPrayerTimes!.times.shomIftor),
                          _buildPrayerTimeTile(
                              "Isha:", uzbPrayerTimes!.times.hufton),
                          _buildPrayerTimeTile("Date:", uzbPrayerTimes!.date),
                          _buildPrayerTimeTile(
                              "Day of week:", uzbPrayerTimes!.weekday),
                          _buildPrayerTimeTile(
                            "Hijri Date:",
                            "${uzbPrayerTimes!.hijriDate.month} ${uzbPrayerTimes!.hijriDate.day}",
                          ),
                        ],
                      )
                    : selectedOption == "International" &&
                            internationalPrayerTimes != null
                        ? ListView(
                            children: [
                              _buildPrayerTimeTile("Fajr:",
                                  internationalPrayerTimes!.timings.fajr),
                              _buildPrayerTimeTile("Dhuhr:",
                                  internationalPrayerTimes!.timings.dhuhr),
                              _buildPrayerTimeTile("Asr:",
                                  internationalPrayerTimes!.timings.asr),
                              _buildPrayerTimeTile("Maghrib:",
                                  internationalPrayerTimes!.timings.maghrib),
                              _buildPrayerTimeTile("Isha:",
                                  internationalPrayerTimes!.timings.isha),
                              _buildPrayerTimeTile("Hijri Date:",
                                  internationalPrayerTimes!.hijri.date),
                              _buildPrayerTimeTile("Hijri Month:",
                                  internationalPrayerTimes!.hijri.month),
                              _buildPrayerTimeTile("Gregorian Date:",
                                  internationalPrayerTimes!.gregorian.date),
                              _buildPrayerTimeTile("Gregorian Month:",
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
