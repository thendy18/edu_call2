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
      // --- Tombol logout dipindahkan ke BODY agar bisa diakses ---
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
            
            // --- TOMBOL LOGOUT DIPINDAHKAN KE SINI (BODY) ---
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                await GoogleAuthService().signOut();
                
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const GoogleLoginScreen()),
                    (route) => false, // Hapus semua history
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            // ------------------------------------------------
          ],
        ),
      ),
    );
  }
}