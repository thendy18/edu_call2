import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/resource_model.dart';
import '../data/resource_service.dart';

class ResourceDetailScreen extends StatefulWidget {
  final ResourceModel resource;

  const ResourceDetailScreen({super.key, required this.resource});

  @override
  State<ResourceDetailScreen> createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen> {
  late TextEditingController _summaryController;
  final ResourceService _resourceService = ResourceService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _summaryController = TextEditingController(text: widget.resource.summary);
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  // membuka URL
  Future<void> _launchURL() async {
    final String url = widget.resource.url;
    if (url.isEmpty) return;
    
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak bisa membuka $url')),
        );
      }
    }
  }

  // menyimpan ringkasan ke Firebase
  Future<void> _saveSummary() async {
    setState(() => _isSaving = true);
    try {
      await _resourceService.updateSummary(widget.resource.id, _summaryController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ringkasan berhasil disimpan!'),
            backgroundColor: Color(0xFF4ADE80),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Materi', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Bagian Header & Link ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      widget.resource.type == 'video' ? Icons.play_circle_outline : 
                      (widget.resource.type == 'pdf' ? Icons.picture_as_pdf : Icons.article_outlined),
                      size: 48, 
                      color: const Color(0xFF6366F1)
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.resource.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.resource.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _launchURL,
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: Text('Buka Sumber Belajar', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --- Bagian Rencana Belajar ---
              Text(
                'Rencana Belajar',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Color(0xFF6366F1)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.resource.learningPlan.isEmpty 
                            ? 'Tidak ada instruksi khusus.' 
                            : widget.resource.learningPlan,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ringkasan Saya',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (_isSaving)
                    const SizedBox(
                      width: 20, height: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    TextButton.icon(
                      onPressed: _saveSummary,
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('Simpan'),
                      style: TextButton.styleFrom(foregroundColor: const Color(0xFF6366F1)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _summaryController,
                maxLines: 8,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Tulis catatan pentingmu di sini...',
                  hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.grey.shade400),
                  filled: true,
                  fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF6366F1)),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}