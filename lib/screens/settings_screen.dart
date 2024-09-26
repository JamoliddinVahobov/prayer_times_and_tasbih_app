import 'package:flutter/material.dart';
import 'package:prayer_times_and_tasbih/change_mode/change_mode.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: FittedBox(child: Text('Sozlamalar')),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text("Rejimni o'zgartirish"),
              value: Provider.of<ThemeNotifier>(context)
                  .isDarkMode, // Boolean value for the switch
              onChanged: (bool value) {
                Provider.of<ThemeNotifier>(context, listen: false)
                    .toggleTheme(); // Toggle theme on switch change
              },
            )
          ],
        ),
      ),
    );
  }
}
