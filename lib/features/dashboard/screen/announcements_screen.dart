import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dashboard/data/announcement_model.dart';
import '../../dashboard/data/announcement_service.dart';
import 'announcement_detail_screen.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final AnnouncementService _service = AnnouncementService();

  void _checkPasswordAndExecute(VoidCallback onSuccess) {
    final passController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Admin Access', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: passController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Masukkan Password',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (passController.text == 'announce') {
                Navigator.pop(context);
                onSuccess(); 
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password Salah!'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Masuk'),
          ),
        ],
      ),
    );
  }

  void _showAddAnnouncementDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    int selectedColor = 0xFF2196F3;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text('Buat Pengumuman', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Judul', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Isi Pengumuman', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedColor,
                    decoration: const InputDecoration(labelText: 'Tipe / Warna'),
                    items: const [
                      DropdownMenuItem(value: 0xFF2196F3, child: Text('ℹ️ Info (Biru)')),
                      DropdownMenuItem(value: 0xFF4CAF50, child: Text('✅ Sukses (Hijau)')),
                      DropdownMenuItem(value: 0xFFFF9800, child: Text('⚠️ Peringatan (Oranye)')),
                      DropdownMenuItem(value: 0xFFF44336, child: Text('🚨 Penting (Merah)')),
                    ],
                    onChanged: (val) => setStateDialog(() => selectedColor = val!),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                onPressed: () async {
                  if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                    try {
                      await _service.addAnnouncement(
                        title: titleController.text,
                        description: descController.text,
                        colorValue: selectedColor,
                      );
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Berhasil diposting!'), backgroundColor: Colors.green),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                child: const Text('Posting', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deleteAnnouncement(String id) async {
    try {
      await _service.deleteAnnouncement(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengumuman dihapus'), backgroundColor: Colors.grey),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengumuman', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _checkPasswordAndExecute(_showAddAnnouncementDialog),
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<List<AnnouncementModel>>(
        stream: _service.getAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.campaign_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('Belum ada pengumuman', style: GoogleFonts.poppins(color: Colors.grey)),
                ],
              ),
            );
          }

          final list = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return AnnouncementCard(
                item: item,
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => AnnouncementDetailScreen(announcement: item)
                    )
                  );
                },
                onDelete: () => _checkPasswordAndExecute(() => _deleteAnnouncement(item.id)),
              ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2, end: 0);
            },
          );
        },
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel item;
  final VoidCallback onTap;
  final VoidCallback onDelete; 

  const AnnouncementCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
            ),
            child: IntrinsicHeight( 
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 6,
                    color: item.color,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: item.color,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Tombol Delete Kecil
                              GestureDetector(
                                onTap: onDelete,
                                child: Icon(Icons.delete_outline, size: 20, color: Colors.grey.shade400),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('d MMM yyyy').format(item.date),
                            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11),
                          ),
                          const Divider(height: 20),
                          Text(
                            item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                "Baca selengkapnya",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey, 
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.grey)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}