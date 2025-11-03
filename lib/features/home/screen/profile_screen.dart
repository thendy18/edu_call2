// lib/features/home/screen/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projek_akhir_edukasi/features/auth/screen/google_login_screen.dart';
import 'package:projek_akhir_edukasi/features/auth/service/google_auth_service.dart';
// ------------------------------------

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'), 
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {

              //  1: LOGOUT LOGIC 
              await GoogleAuthService().signOut();
              
              if (context.mounted) {
                // PERBAIKAN 2: NAVIGASI 
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const GoogleLoginScreen()),
                  (route) => false, // Hapus semua history
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cek foto
            if (user?.photoURL != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user!.photoURL!),
              )
            else
              // avatar default jika tidak ada foto
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            const SizedBox(height: 20),
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              user?.displayName ?? 'User',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            Text(
              user?.email ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}