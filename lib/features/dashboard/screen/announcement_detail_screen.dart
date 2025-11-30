import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../dashboard/data/announcement_model.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final AnnouncementModel announcement;

  const AnnouncementDetailScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori / Chip Warna
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: announcement.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: announcement.color.withOpacity(0.5)),
              ),
              child: Text(
                _getCategoryName(announcement.colorValue),
                style: GoogleFonts.poppins(
                  color: announcement.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Judul Besar
            Text(
              announcement.title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            
            // Tanggal
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  DateFormat('EEEE, d MMMM yyyy • HH:mm').format(announcement.date),
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Divider(color: isDark ? Colors.white24 : Colors.grey.shade200),
            const SizedBox(height: 24),

            // Isi Pengumuman
            Text(
              announcement.description,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk nama kategori berdasarkan warna
  String _getCategoryName(int colorValue) {
    switch (colorValue) {
      case 0xFF2196F3: return 'Informasi';
      case 0xFF4CAF50: return 'Sukses';
      case 0xFFFF9800: return 'Peringatan';
      case 0xFFF44336: return 'Penting';
      default: return 'Pengumuman';
    }
  }
}