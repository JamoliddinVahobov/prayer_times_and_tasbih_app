import 'package:flutter/material.dart';
import 'package:prayer_times_and_tasbih/bottomnavigation/bottombar.dart';
import 'package:prayer_times_and_tasbih/change_mode/change_mode.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, themeNotifier, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namoz Vaqtlari va Tasbeh',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            error: Colors.red, // Define error color here
            onError: Colors.white, // Color of text/icons on error
            surface: Colors.white, // Light background replacement
            onSurface: Colors.black, // Text/icons on light background
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
                  Colors.blue, // Set text color to blue in light mode
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white, // Background color for light mode
            selectedItemColor:
                Color(0xFF0D47A1), // Darker blue for selected item
            unselectedItemColor:
                Color(0xFF757575), // Unselected item color in light mode
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF2D2B26), // Slight brown tint
          primaryColor: Colors.grey.shade800,
          colorScheme: ColorScheme.dark(
            primary: Colors.grey.shade800,
            onPrimary: Colors.white,
            surface: const Color(0xFF3C3A36), // Dark background replacement
            onSurface: Colors.white, // Text/icons on dark background
            error: Colors.redAccent, // Custom error color for dark theme
            onError: Colors.white, // Text color for error messages
          ),

          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2D2B26),
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white), // For larger body text
            bodyMedium: TextStyle(color: Colors.white), // For smaller body text
            labelLarge: TextStyle(color: Colors.white), // For labels/buttons
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
                  Colors.white, // Set text color to white in dark mode
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor:
                Color(0xFF2D2B26), // Background color for dark mode
            selectedItemColor: Colors.white, // Selected item color in dark mode
            unselectedItemColor:
                Colors.grey, // Unselected item color in dark mode
          ),
        ),
        themeMode: themeNotifier.isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light, // Toggle between light and dark modes
        home: const BottomNavigationBarClass(),
      );
    });
  }
}
