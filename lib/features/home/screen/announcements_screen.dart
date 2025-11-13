// lib/features/home/screen/announcements_screen.dart
import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          // Pengumuman 1
          AnnouncementCard(
            title: '📣 Rapat Persiapan Ujian Sekolah (US)',
            date: '6 November 2025',
            description: 'Diingatkan kepada seluruh siswa kelas 12 untuk '
                         'bergabung ke video call rapat persiapan US besok pagi '
                         'jam 08:00. Link akan dibagikan 15 menit sebelumnya.',
            color: Colors.blue,
          ),

          // Pengumuman 2
          AnnouncementCard(
            title: '📚 Materi Baru Biologi Telah Di-upload',
            date: '5 November 2025',
            description: 'Materi "Materi 3: Pengantar Genetika" sudah tersedia '
                         'di menu Materi. Silakan dipelajari untuk '
                         'mengerjakan Tugas 3.',
            color: Colors.green,
          ),
          
          // Pengumuman 3
          AnnouncementCard(
            title: '⚠️ Pembatalan Kelas Matematika',
            date: '4 November 2025',
            description: 'Kelas Matematika Peminatan hari ini ditiadakan '
                         'karena guru berhalangan hadir. Gunakan waktu '
                         'untuk mengerjakan Tugas 2.',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

// Widget kustom untuk kartu pengumuman
class AnnouncementCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final Color color;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color, width: 2), // Garis warna di pinggir
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color, // Warna judul
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const Divider(height: 20),
            Text(description),
          ],
        ),
      ),
    );
  }
}