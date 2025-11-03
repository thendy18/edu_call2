// lib/features/home/screen/app_main_screen.dart

import 'package:flutter/material.dart';
import 'package:projek_akhir_edukasi/features/home/screen/home_screen.dart';
import 'package:projek_akhir_edukasi/features/home/screen/profile_screen.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int _page = 0; // Halaman yang sedang aktif

  // Daftar halaman yang akan ditampilkan
  List<Widget> pages = [
    // Halaman 0: Home
    const HomeScreen(), 
    
    // Halaman 1: Profile
    const ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TAMBAHKAN APPBAR DI SINI agar Bottom Bar tidak tertutup
      // Kita setel judulnya secara dinamis
      appBar: AppBar(
        title: Text(_page == 0 ? 'Home' : 'Profile'),
        elevation: 0,
        centerTitle: true,
      ),
      
      // Halaman yang sedang aktif
      body: pages[_page], 
      
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}