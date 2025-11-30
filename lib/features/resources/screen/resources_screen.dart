import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/resource_model.dart';
import '../data/resource_service.dart';
import 'resource_detail_screen.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final ResourceService _resourceService = ResourceService();

  IconData _getIcon(String type) {
    switch (type) {
      case 'video': return Icons.play_circle_outline;
      case 'pdf': return Icons.picture_as_pdf;
      case 'article': return Icons.article_outlined;
      default: return Icons.folder_open;
    }
  }

  // --- LOGIKA 1: Hapus Resource (Dengan Konfirmasi) ---
  void _confirmDelete(String id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus Materi?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(
          'Apakah Anda yakin ingin menghapus materi "$title"?\nTindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Tutup dialog
              _deleteResource(id); // Langsung hapus
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteResource(String id) async {
    try {
      await _resourceService.deleteResource(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Materi dihapus'), backgroundColor: Colors.grey),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // --- LOGIKA 2: Tambah Resource (Tanpa Password, Tapi Ada Konfirmasi Simpan) ---
  void _showAddResourceDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final urlController = TextEditingController();
    final planController = TextEditingController();
    String selectedType = 'video';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                // Tampilkan Konfirmasi "Apakah Anda Yakin?"
                showDialog(
                  context: context,
                  builder: (confirmContext) => AlertDialog(
                    title: Text("Konfirmasi", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    content: Text("Apakah Anda yakin ingin menambahkan materi ini?", style: GoogleFonts.poppins()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(confirmContext), // Tutup konfirmasi
                        child: const Text("Cek Lagi", style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // 1. Tutup Konfirmasi
                          Navigator.pop(confirmContext);
                          // 2. Tutup Form Input
                          Navigator.pop(dialogContext);
                          
                          // 3. Simpan ke Database
                          await _resourceService.addResource(
                            title: titleController.text,
                            description: descController.text,
                            url: urlController.text,
                            learningPlan: planController.text,
                            type: selectedType,
                          );

                          // 4. Feedback
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Materi berhasil ditambahkan'), 
                                backgroundColor: Color(0xFF4ADE80)
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                        child: const Text("Ya, Simpan", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // Langsung buka form tanpa password
        onPressed: _showAddResourceDialog,
        backgroundColor: const Color(0xFF6366F1),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Tambah', style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        ),
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
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
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
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.grey.shade400),
                      onPressed: () {
                        // Konfirmasi hapus tanpa password
                        _confirmDelete(item.id, item.title);
                      },
                    ),
                    onTap: () {
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