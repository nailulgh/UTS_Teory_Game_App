import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'view/home.dart';
import 'view/detail.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F0F23),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NexusGame Store - Katalog Game FreeToGame',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F23),
        primaryColor: const Color(0xFF7C3AED),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7C3AED),
          secondary: Color(0xFFA78BFA),
          tertiary: Color(0xFFF59E0B),
          surface: Color(0xFF1E1C35),
          onPrimary: Colors.white,
          onSurface: Color(0xFFF8FAFC),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/detail': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final gameId = (args is int) ? args : 540;
          return Detail(gameTerpilih: gameId);
        },
      },
    );
  }
}
