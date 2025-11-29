import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_akhir_edukasi/features/academic/screen/classes_screen.dart'; // Import halaman baru
import 'package:projek_akhir_edukasi/features/meeting/meeting_screen.dart';
import 'package:projek_akhir_edukasi/features/meeting/start_meeting_screen.dart';
import 'package:projek_akhir_edukasi/features/tasks/screen/tasks_screen.dart';
import 'package:projek_akhir_edukasi/features/resources/screen/resources_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startNewMeeting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StartMeetingScreen(),
      ),
    );
  }

  void _showJoinDialog(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final TextEditingController meetingIdController = TextEditingController();
    final TextEditingController nameController = TextEditingController(
      text: user?.displayName ?? '',
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Join Meeting',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: meetingIdController,
                      decoration: InputDecoration(
                        labelText: 'Meeting ID',
                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey.shade600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.3)
                                : Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.3)
                                : Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF6366F1),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade50,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey.shade600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.3)
                                : Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(0.3)
                                : Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF6366F1),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade50,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final meetingId =
                                  meetingIdController.text.trim();
                              final name = nameController.text.trim();

                              if (meetingId.isEmpty || name.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please fill in Meeting ID and Your Name',
                                    ),
                                  ),
                                );
                                return;
                              }

                              Navigator.pop(dialogContext);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MeetingScreen(
                                    meetingID: meetingId,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Text('Join'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userName = user?.displayName ?? 'Student';

    // Mock data untuk preview di Home (hanya menampilkan data ringkas)
    final List<Map<String, String>> previewClasses = [
      {'title': 'Matematika Diskrit', 'subtitle': 'Hari ini pukul 08:00'},
      {'title': 'Pemrograman Mobile', 'subtitle': 'Hari ini pukul 13:00'},
      {'title': 'Basis Data', 'subtitle': 'Besok pukul 10:00'},
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $userName!',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey.shade900,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 8),
                  Text(
                    'Ready to learn today?',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: isDark
                          ? Colors.white.withOpacity(0.7)
                          : Colors.grey.shade600,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideX(begin: -0.2, end: 0),
                ],
              ),
            ),

            // Action Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  // New Meeting Card
                  Expanded(
                    child: _ActionCard(
                      title: 'New Meeting',
                      icon: Icons.videocam,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF6B6B),
                          Color(0xFFFF8E53),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => _startNewMeeting(context),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                  ),
                  const SizedBox(width: 16),
                  // Join Meeting Card
                  Expanded(
                    child: _ActionCard(
                      title: 'Join Meeting',
                      icon: Icons.add_box_rounded,
                      isGlass: true,
                      onTap: () => _showJoinDialog(context),
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                  ),
                ],
              ),
            ),

            // Additional Action Buttons (Tugas & Materi)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      title: 'Tugas',
                      icon: Icons.assignment,
                      isGlass: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TasksScreen(),
                          ),
                        );
                      },
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ActionCard(
                      title: 'Materi',
                      icon: Icons.topic,
                      isGlass: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResourcesScreen(),
                          ),
                        );
                      },
                    )
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                  ),
                ],
              ),
            ),

            // Upcoming Classes Section (UPDATED)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kelas Mendatang',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey.shade900,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClassesScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Lihat Semua',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 600.ms)
                  .slideX(begin: -0.2, end: 0),
            ),

            // Classes List (Preview only)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: previewClasses.length,
              itemBuilder: (context, index) {
                final item = previewClasses[index];
                return _HistoryTile(
                  title: item['title']!,
                  subtitle: item['subtitle']!,
                )
                    .animate()
                    .fadeIn(delay: (900 + (index * 100)).ms, duration: 600.ms)
                    .slideX(begin: -0.2, end: 0);
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Action Card Widget (Tetap sama)
class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Gradient? gradient;
  final bool isGlass;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.gradient,
    this.isGlass = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            color: isGlass
                ? (isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.9))
                : null,
            borderRadius: BorderRadius.circular(20),
            border: isGlass
                ? Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white.withOpacity(0.5),
                    width: 1.5,
                  )
                : null,
            boxShadow: gradient != null
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF6B6B).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
          ),
          child: isGlass
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 40,
                          color: isDark
                              ? Colors.white.withOpacity(0.9)
                              : Colors.grey.shade800,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white.withOpacity(0.9)
                                : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// History Tile Widget (Tetap sama)
class _HistoryTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HistoryTile({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6366F1).withOpacity(0.8),
                    const Color(0xFF8B5CF6).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 24,
              ),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.grey.shade900,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: isDark
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey.shade600,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDark
                  ? Colors.white.withOpacity(0.5)
                  : Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}