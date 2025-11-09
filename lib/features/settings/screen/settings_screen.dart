// lib/features/settings/screen/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projek_akhir_edukasi/features/settings/provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Impor url_launcher

// --- PERUBAHAN: Ubah dari StatelessWidget menjadi ConsumerWidget ---
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  // Fungsi helper untuk membuka URL (dari resources_screen)
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print('Tidak bisa membuka $url');
    }
  }

  @override
  // Tambahkan 'WidgetRef ref'
  Widget build(BuildContext context, WidgetRef ref) {
    // Ambil state tema saat ini
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      // Kita tidak perlu AppBar, karena app_main_screen sudah punya
      body: ListView(
        children: [
          // --- Bagian 1: Mode Gelap ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tampilan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Mode Gelap'),
            secondary: Icon(
              themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            ),
            // value = true jika tema saat ini adalah dark
            value: themeMode == ThemeMode.dark,
            // onChanged: panggil fungsi toggleTheme di provider
            onChanged: (isDark) {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),

          const Divider(),

          // --- Bagian 2: Tautan Informasi ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Lainnya',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            onTap: () {
              // TODO: Ganti dengan halaman "Tentang" Anda
              showAboutDialog(
                context: context,
                applicationName: 'Edu Call',
                applicationVersion: '1.0.0',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Kebijakan Privasi'),
            onTap: () {
              // TODO: Ganti dengan URL Kebijakan Privasi Anda
              _launchURL('https://www.google.com/policies/privacy/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('Laporkan Masalah'),
            onTap: () {
              // TODO: Ganti dengan URL Google Form Anda
              _launchURL('https://forms.gle/your-form-id');
            },
          ),
        ],
      ),
    );
  }
}