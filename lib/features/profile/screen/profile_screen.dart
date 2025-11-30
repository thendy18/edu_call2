import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:projek_akhir_edukasi/features/auth/screen/google_login_screen.dart';
import 'package:projek_akhir_edukasi/features/auth/service/google_auth_service.dart';
import 'package:projek_akhir_edukasi/features/settings/provider/theme_provider.dart';
// Sesuaikan path import ini dengan struktur folder Anda
import 'package:projek_akhir_edukasi/features/profile/service/profile_service.dart'; 

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final User? user = FirebaseAuth.instance.currentUser;

  // Controllers untuk Form
  late TextEditingController _nameController;
  late TextEditingController _nimController;
  late TextEditingController _majorController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  bool _isEditing = false; // Status apakah sedang mode edit atau baca
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data default dari Auth (jika ada)
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _nimController = TextEditingController();
    _majorController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _majorController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Fungsi Simpan Data
  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      await _profileService.updateUserProfile(
        fullName: _nameController.text,
        nim: _nimController.text,
        major: _majorController.text,
        phone: _phoneController.text,
        bio: _bioController.text,
      );
      
      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark || (themeMode == ThemeMode.system && Theme.of(context).brightness == Brightness.dark);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Profil Saya', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        actions: [
          // Tombol Edit / Simpan di Pojok Kanan Atas
          IconButton(
            onPressed: _isLoading ? null : () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
            icon: _isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(_isEditing ? Icons.check : Icons.edit_note, size: 28, color: const Color(0xFF6366F1)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _profileService.getUserStream(),
        builder: (context, snapshot) {
          // Update controller text jika data baru masuk dari database (Hanya jika TIDAK sedang mengedit)
          if (snapshot.hasData && snapshot.data!.exists && !_isEditing) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            _nameController.text = data['fullName'] ?? user?.displayName ?? '';
            _nimController.text = data['nim'] ?? '';
            _majorController.text = data['major'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _bioController.text = data['bio'] ?? '';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // --- PROFILE HEADER ---
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF6366F1), width: 3),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                          backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                          child: user?.photoURL == null
                              ? Icon(Icons.person, size: 60, color: Colors.grey.shade400)
                              : null,
                        ),
                      ),
                      // Ikon Kamera (Hanya visual untuk saat ini)
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF6366F1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                    ],
                  ).animate().scale(),
                ),
                
                const SizedBox(height: 16),
                Text(
                  user?.email ?? '',
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // --- FORM FIELDS SECTION ---
                _buildSectionHeader('Informasi Pribadi', isDark),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  icon: Icons.person_outline,
                  isDark: isDark,
                  enabled: _isEditing,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _bioController,
                  label: 'Bio / Status',
                  icon: Icons.info_outline,
                  isDark: isDark,
                  enabled: _isEditing,
                  maxLines: 2,
                ),

                const SizedBox(height: 24),
                _buildSectionHeader('Data Akademik & Kontak', isDark),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _nimController,
                        label: 'NIM',
                        icon: Icons.badge_outlined,
                        isDark: isDark,
                        enabled: _isEditing,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _majorController,
                        label: 'Jurusan',
                        icon: Icons.school_outlined,
                        isDark: isDark,
                        enabled: _isEditing,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Nomor WhatsApp',
                  icon: Icons.phone_outlined,
                  isDark: isDark,
                  enabled: _isEditing,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 40),

                // --- SETTINGS SECTION ---
                _buildSectionHeader('Pengaturan', isDark),
                const SizedBox(height: 16),
                
                // Theme Toggle
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.orange),
                    ),
                    title: Text(isDark ? 'Light Mode' : 'Dark Mode', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    trailing: Switch(
                      value: isDark,
                      activeColor: const Color(0xFF6366F1),
                      onChanged: (val) {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await GoogleAuthService().signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const GoogleLoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      foregroundColor: Colors.red,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Log Out', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildSectionHeader(String title, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool enabled = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        color: isDark ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
        prefixIcon: Icon(icon, color: enabled ? const Color(0xFF6366F1) : Colors.grey),
        filled: true,
        fillColor: enabled 
            ? (isDark ? Colors.white.withOpacity(0.05) : Colors.white)
            : (isDark ? Colors.white.withOpacity(0.02) : Colors.grey.shade100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: isDark ? Colors.transparent : Colors.grey.shade100),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}