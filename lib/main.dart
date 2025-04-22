import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mysolat_app/services/prayer_provider.dart';
import 'package:mysolat_app/services/api_service.dart';
import 'package:mysolat_app/screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PrayerProvider(
            apiService: ApiService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'MySolat App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E8B57), // Sea Green
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E8B57), // Sea Green
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
} 