// lib/main.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:projek_akhir_edukasi/features/auth/screen/google_login_screen.dart';
import 'package:projek_akhir_edukasi/features/home/screen/app_main_screen.dart';
import 'package:projek_akhir_edukasi/features/settings/provider/theme_provider.dart'; 
import 'package:projek_akhir_edukasi/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final prefs = await SharedPreferences.getInstance();
    runApp(
      ProviderScope(
        overrides: [
          // Baris ini (line 23) sekarang akan valid
          sharedPreferencesProvider.overrideWithValue(prefs), 
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 20),
              const Text('Firebase Initialization Error'),
              const SizedBox(height: 10),
              Text(e.toString()),
            ],
          ),
        ),
      ),
    ));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final themeMode = ref.watch(themeProvider);

    // Warna "elegan"
    const Color elegantPurple = Color(0xFFE0BBE4); 

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edu Call', 
      
      themeMode: themeMode,

      // --- TEMA TERANG (LIGHT MODE) ---
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: elegantPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: false, 
      ),

      // --- TEMA GELAP (DARK MODE) ---
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: elegantPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: false,
      ),

      // StreamBuilder untuk Auth
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const AppMainScreen(); // Jika sudah login
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return const GoogleLoginScreen(); // Jika belum login
        },
      ),
    );
  }
}