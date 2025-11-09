// lib/features/home/screen/resources_screen.dart
import 'package:flutter/material.dart';
// 1. Impor package yang baru saja kita tambahkan
import 'package:url_launcher/url_launcher.dart'; 

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({Key? key}) : super(key: key);

  // 2. Buat fungsi helper untuk membuka URL
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Tampilkan pesan error jika gagal membuka link
      print('Tidak bisa membuka $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materi Belajar'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Materi 1 (Berhubungan dengan Tugas 1)
          ResourceCard(
            title: 'Materi 1: Pengantar Integral',
            description: 'Video penjelasan konsep integral tak tentu sebagai anti-turunan.',
            icon: Icons.play_circle_outline, 
            onTap: () {
              // 3. Panggil fungsi _launchURL dengan link sungguhan
              _launchURL('https://youtu.be/6WUjbJEeJwM?si=L43luDQGA_oqZbDJ');
            },
          ),
          
          // Materi 2 (Berhubungan dengan Tugas 2)
          ResourceCard(
            title: 'Materi 2: Rumus Dasar Integral',
            description: 'Catatan ringkas (PDF) rumus-rumus integral aljabar.',
            icon: Icons.picture_as_pdf, 
            onTap: () {
              _launchURL('https://solmath.weebly.com/uploads/4/4/2/9/44298799/materi__integral.pdf');
            },
          ),

          // Materi 3 (Berhubungan dengan Tugas 3)
          ResourceCard(
            title: 'Materi 3: Pengantar Genetika',
            description: 'Artikel penjelasan mengenai Hukum Mendel I dan II.',
            icon: Icons.article_outlined, 
            onTap: () {
              _launchURL('https://id.wikipedia.org/wiki/Pengantar_genetika');
            },
          ),

          // Materi Tambahan
           ResourceCard(
            title: 'Materi 4: Bank Soal SNBT',
            description: 'Kumpulan soal-soal SNBT tahun-tahun sebelumnya.',
            icon: Icons.folder_open, 
            onTap: () {
              _launchURL('https://drive.google.com/drive/folders/11gfiSZnfr8AciYYoMFT8oNPRoqQw1Fku');
            },
          ),
        ],
      ),
    );
  }
}

// --- Widget ResourceCard (Tidak berubah) ---
class ResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const ResourceCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(icon, size: 40, color: Colors.blue.shade700),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}