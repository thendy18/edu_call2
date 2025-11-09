// // lib/features/settings/provider/theme_provider.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// const String _themePrefsKey = 'themeMode';

// class ThemeNotifier extends Notifier<ThemeMode> {
//   @override
//   ThemeMode build() {
//     // Load theme saat pertama kali build
//     _loadTheme();
//     return ThemeMode.light; // Default value, akan di-update oleh _loadTheme
//   }

//   Future<void> _loadTheme() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final themeString = prefs.getString(_themePrefsKey);
      
//       if (themeString == 'dark') {
//         state = ThemeMode.dark;
//       } else {
//         state = ThemeMode.light;
//       }
//     } catch (e) {
//       state = ThemeMode.light;
//     }
//   }

//   Future<void> toggleTheme() async {
//     try {
//       final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//       final prefs = await SharedPreferences.getInstance();
      
//       await prefs.setString(_themePrefsKey, newTheme == ThemeMode.dark ? 'dark' : 'light');
//       state = newTheme;
//     } catch (e) {
//       print('Error toggling theme: $e');
//     }
//   }

//   Future<void> setTheme(ThemeMode theme) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_themePrefsKey, theme == ThemeMode.dark ? 'dark' : 'light');
//       state = theme;
//     } catch (e) {
//       print('Error setting theme: $e');
//     }
//   }
// }

// final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
//   return ThemeNotifier();
// });

// lib/features/settings/provider/theme_provider.dart

// --- INI ADALAH 3 BARIS PENTING YANG HILANG ---
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- Ini untuk Riverpod
import 'package:shared_preferences/shared_preferences.dart'; // <-- Ini untuk SharedPreferences
// --------------------------------------------------

// Key untuk menyimpan di SharedPreferences
const String _themePrefsKey = 'themeMode';

// 1. Provider untuk SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Akan di-override di main.dart
});

// 2. Provider utama untuk Tema
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs: prefs);
});

// 3. Class Notifier (Si "Otak")
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeNotifier({required SharedPreferences prefs})
      : _prefs = prefs,
        super(prefs.getString(_themePrefsKey) == 'dark'
            ? ThemeMode.dark
            : ThemeMode.light);

  // Fungsi untuk mengganti tema
  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _prefs.setString(_themePrefsKey, newTheme == ThemeMode.dark ? 'dark' : 'light');
    state = newTheme;
  }
}