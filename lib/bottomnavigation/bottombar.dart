import 'package:flutter/material.dart';
import 'package:prayer_times_and_tasbih/screens/prayer_times_screen.dart';
import 'package:prayer_times_and_tasbih/screens/settings_screen.dart';
import 'package:prayer_times_and_tasbih/screens/tasbih_screen.dart';

class BottomNavigationBarClass extends StatefulWidget {
  const BottomNavigationBarClass({super.key});

  @override
  BottomNavigationBarClassState createState() =>
      BottomNavigationBarClassState();
}

class BottomNavigationBarClassState extends State<BottomNavigationBarClass> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const PrayerTimesScreen(),
    const TasbihScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 0
                  ? Icons.access_alarm // Filled icon for selected
                  : Icons.access_alarm_outlined, // Outlined icon for unselected
            ),
            label: 'Prayer Times',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 1
                  ? Icons.circle // Filled icon for selected
                  : Icons.circle_outlined, // Outlined icon for unselected
            ),
            label: 'Tasbih',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 2
                  ? Icons.settings // Filled icon for selected
                  : Icons.settings_outlined, // Outlined icon for unselected
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
