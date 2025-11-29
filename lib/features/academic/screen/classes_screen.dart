import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_akhir_edukasi/features/academic/screen/class_detail_screen.dart';

// Model Sederhana untuk Kelas
class ClassModel {
  final String id;
  final String title;
  final String lecturer;
  final String time;
  final String room;
  bool isPresent;
  final bool isToday;

  ClassModel({
    required this.id,
    required this.title,
    required this.lecturer,
    required this.time,
    required this.room,
    this.isPresent = false,
    this.isToday = true,
  });
}

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data (Nantinya bisa dari API/Database)
  final List<ClassModel> _classes = [
    ClassModel(
      id: '1',
      title: 'Matematika Diskrit',
      lecturer: 'Dr. Budi Santoso',
      time: '08:00 - 10:00',
      room: 'R. 304',
      isToday: true,
    ),
    ClassModel(
      id: '2',
      title: 'Pemrograman Mobile',
      lecturer: 'Ibu Siti Aminah',
      time: '13:00 - 15:00',
      room: 'Lab Komputer 2',
      isToday: true,
    ),
    ClassModel(
      id: '3',
      title: 'Basis Data',
      lecturer: 'Pak Joko',
      time: '10:00 - 12:00',
      room: 'R. 202',
      isToday: false, // Kemarin/Besok
      isPresent: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleAttendance(String id) {
    setState(() {
      final index = _classes.indexWhere((c) => c.id == id);
      if (index != -1) {
        _classes[index].isPresent = !_classes[index].isPresent;
      }
    });
    
    // Feedback SnackBar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status kehadiran diperbarui!'),
        backgroundColor: const Color(0xFF6366F1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final todayClasses = _classes.where((c) => c.isToday).toList();
    final historyClasses = _classes.where((c) => !c.isToday).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Jadwal Kelas',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, 
            color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6366F1),
          labelColor: isDark ? Colors.white : const Color(0xFF6366F1),
          unselectedLabelColor: isDark ? Colors.white60 : Colors.grey,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Hari Ini'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          // Background gradient konsisten dengan Home
           color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildClassList(todayClasses, isDark, isTodayTab: true),
            _buildClassList(historyClasses, isDark, isTodayTab: false),
          ],
        ),
      ),
    );
  }

  Widget _buildClassList(List<ClassModel> classes, bool isDark, {required bool isTodayTab}) {
    if (classes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Tidak ada jadwal kelas',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 120, 24, 24), // Top padding for AppBar
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final item = classes[index];
        return _ClassCard(
          item: item,
          isDark: isDark,
          onAttendanceChanged: () => _toggleAttendance(item.id),
        ).animate().fadeIn(delay: (100 * index).ms).slideX();
      },
    );
  }
}

class _ClassCard extends StatelessWidget {
  final ClassModel item;
  final bool isDark;
  final VoidCallback onAttendanceChanged;

  const _ClassCard({
    required this.item,
    required this.isDark,
    required this.onAttendanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isPresent 
              ? const Color(0xFF4ADE80) // Green border if present
              : (isDark ? Colors.white10 : Colors.grey.shade200),
          width: item.isPresent ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // NAVIGASI KE DETAIL KELAS
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassDetailScreen(
                    className: item.title,
                    lecturer: item.lecturer,
                    room: item.room,
                    time: item.time,
                  ),
                ),
              );
            }, 
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Time Container
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.time.split('-')[0].trim(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6366F1),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'WIB',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: const Color(0xFF6366F1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.grey.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.lecturer,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              item.room,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Checkbox Kehadiran
                  Column(
                    children: [
                      Text(
                        'Hadir',
                        style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey),
                      ),
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: item.isPresent,
                          activeColor: const Color(0xFF4ADE80),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          onChanged: (val) => onAttendanceChanged(),
                        ),
                      ),
                    ],
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