// lib/features/home/screen/app_main_screen.dart
import 'package:flutter/material.dart';
import 'package:projek_akhir_edukasi/features/chat/screen/chat_screen.dart';
import 'package:projek_akhir_edukasi/features/dashboard/screen/home_screen.dart';
import 'package:projek_akhir_edukasi/features/profile/screen/profile_screen.dart';
import 'package:projek_akhir_edukasi/features/dashboard/screen/announcements_screen.dart';
import 'package:projek_akhir_edukasi/features/settings/screen/settings_screen.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _page = 0; // Halaman yang sedang aktif

  List<Widget> pages = [
    // Halaman 0: Home
    const HomeScreen(),

    // Halaman 1: AI Chat
    const ChatScreen(),

    // Halaman 2: Pengumuman
    const AnnouncementsScreen(),

    // Halaman 3: Settings
    const SettingsScreen(),

    // Halaman 4: Profile
    const ProfileScreen(),
  ];

  List<String> pageTitles = [
    'Home',
    'AI Chat',
    'Pengumuman',
    'Settings',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Judul AppBar dinamis sesuai halaman
        title: Text(pageTitles[_page]),
        elevation: 0,
        centerTitle: true,
      ),

      // Halaman yang sedang aktif
      body: pages[_page],

      // Bottom Navigation Bar
      bottomNavigationBar: SafeArea(
        // Kita pertahankan SafeArea
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'AI Chat',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.campaign_outlined),
              label: 'Pengumuman',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),

            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
