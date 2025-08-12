import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/auth_screen.dart';
import 'models/credential.dart';
import 'models/address.dart';
import 'models/card_info.dart';
import 'models/secure_note.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapters
  await Hive.initFlutter();
  Hive.registerAdapter(CredentialAdapter());
  Hive.registerAdapter(AddressAdapter());
  Hive.registerAdapter(CardInfoAdapter());
  Hive.registerAdapter(SecureNoteAdapter());

  await StorageService.init(); // Open Hive boxes

  runApp(CoalAuthApp());
}

class CoalAuthApp extends StatelessWidget {
  const CoalAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF024A9E);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoalAuth Secure',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryBlue,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: primaryBlue,
        colorScheme: ColorScheme.dark(primary: primaryBlue),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: AuthScreen(),
    );
  }
}
