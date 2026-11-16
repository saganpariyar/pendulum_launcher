import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF020617),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  await StorageService.init();
  runApp(const PendulumLauncherApp());
}

class PendulumLauncherApp extends StatelessWidget {
  const PendulumLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pendulum Launcher',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF020617),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFC084FC),
          secondary: Color(0xFFFB923C),
          surface: Color(0xFF0F172A),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
