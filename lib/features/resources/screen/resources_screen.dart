import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/resource_model.dart';
import '../data/resource_service.dart';
import 'resource_detail_screen.dart';

class ResourcesScreen extends StatelessWidget {
  ResourcesScreen({super.key});

  final ResourceService _resourceService = ResourceService();

  // Helper Icon berdasarkan tipe
  IconData _getIcon(String type) {
    switch (type) {
      case 'video': return Icons.play_circle_outline;
      case 'pdf': return Icons.picture_as_pdf;
      case 'article': return Icons.article_outlined;
      default: return Icons.folder_open;
    }
  }

  // Dialog Tambah Materi
  void _showAddResourceDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final urlController = TextEditingController();
    final planController = TextEditingController();
    String selectedType = 'video';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Materi Baru', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul Materi'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Deskripsi Singkat'),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'Link / URL'),
              ),
              TextField(
                controller: planController,
                decoration: const InputDecoration(labelText: 'Rencana Belajar'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: const [
                  DropdownMenuItem(value: 'video', child: Text('Video')),
                  DropdownMenuItem(value: 'pdf', child: Text('PDF / Dokumen')),
                  DropdownMenuItem(value: 'article', child: Text('Artikel')),
                ],
                onChanged: (value) => selectedType = value!,
                decoration: const InputDecoration(labelText: 'Tipe Materi'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                // Panggil Service untuk simpan ke Firebase
                await _resourceService.addResource(
                  title: titleController.text,
                  description: descController.text,
                  url: urlController.text,
                  learningPlan: planController.text,
                  type: selectedType,
                );
                if (context.mounted) Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Materi Belajar', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      // Tombol Tambah Mengambang
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddResourceDialog(context),
        backgroundColor: const Color(0xFF6366F1),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Tambah', style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        ),
        // Menggunakan StreamBuilder untuk data Real-time
        child: StreamBuilder<List<ResourceModel>>(
          stream: _resourceService.getResources(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.library_books_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text('Belum ada materi', style: GoogleFonts.poppins(color: Colors.grey)),
                  ],
                ),
              );
            }

            final resources = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 80),
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final item = resources[index];
                
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_getIcon(item.type), color: const Color(0xFF6366F1), size: 32),
                    ),
                    title: Text(
                      item.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        item.description,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    onTap: () {
                      // Navigasi ke Detail Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResourceDetailScreen(resource: item),
                        ),
                      );
                    },
                  ),
                ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2, end: 0);
              },
            );
          },
        ),
      ),
    );
  }
}