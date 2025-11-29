// lib/features/home/screen/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projek_akhir_edukasi/features/auth/screen/google_login_screen.dart';
import 'package:projek_akhir_edukasi/features/auth/service/google_auth_service.dart';
import 'package:projek_akhir_edukasi/features/settings/provider/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Avatar
              if (user?.photoURL != null)
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(user!.photoURL!),
                )
              else
                CircleAvatar(
                  radius: 60,
                  backgroundColor: isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.shade200,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : Colors.grey.shade600,
                  ),
                ),

              const SizedBox(height: 24),

              // Welcome Text
              Text(
                'Welcome!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),

              const SizedBox(height: 8),

              // Display Name
              Text(
                user?.displayName ?? 'User',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),

              const SizedBox(height: 4),

              // Email
              Text(
                user?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.7)
                          : Colors.grey.shade600,
                    ),
              ),

              const SizedBox(height: 48),

              // Theme Switcher Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                  label: Text(isDark ? 'Light Mode' : 'Dark Mode'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.shade100,
                    foregroundColor: isDarkMode
                        ? Colors.white
                        : Colors.grey.shade800,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await GoogleAuthService().signOut();

                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const GoogleLoginScreen(),
                        ),
                        (route) => false, // Hapus semua history
                      );
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
