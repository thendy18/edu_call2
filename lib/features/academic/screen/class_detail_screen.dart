import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class ClassDetailScreen extends StatefulWidget {
  final String className;
  final String lecturer;
  final String room;
  final String time;

  const ClassDetailScreen({
    super.key,
    required this.className,
    required this.lecturer,
    required this.room,
    required this.time,
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data: 16 Pertemuan
  // Di aplikasi nyata, ini diambil dari Database/API berdasarkan Class ID
  final List<Map<String, dynamic>> _sessions = List.generate(16, (index) {
    return {
      'week': index + 1,
      'topic': 'Topik Pembahasan Minggu ke-${index + 1}',
      'date': DateTime.now().add(Duration(days: index * 7)),
      'isPresent': index < 5, // Mock: 5 pertemuan awal sudah hadir
      'isLocked': index > 5, // Mock: Pertemuan masa depan terkunci
    };
  });

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

  void _toggleAttendance(int index) {
    if (_sessions[index]['isLocked']) return; // Jangan ubah jika terkunci

    setState(() {
      _sessions[index]['isPresent'] = !_sessions[index]['isPresent'];
    });
  }

  double _calculateAttendancePercentage() {
    int totalPresent = _sessions.where((s) => s['isPresent'] == true).length;
    return (totalPresent / 16) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black26 : Colors.white54,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_new, size: 18, color: isDark ? Colors.white : Colors.black87),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Kelas',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        ),
        child: Column(
          children: [
            // Header Info Kelas
            _buildClassHeader(isDark),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: isDark ? Colors.grey : Colors.grey.shade600,
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Pertemuan'),
                  Tab(text: 'Statistik'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab View Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSessionsList(isDark),
                  _buildStatisticsTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Header Informasi Kelas
  Widget _buildClassHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.className,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: const Color(0xFF6366F1)),
              const SizedBox(width: 8),
              Text(
                widget.lecturer,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: const Color(0xFF6366F1)),
              const SizedBox(width: 8),
              Text(
                '${widget.room} • ${widget.time}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  // TAB 1: Daftar 16 Pertemuan
  Widget _buildSessionsList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: _sessions.length,
      itemBuilder: (context, index) {
        final session = _sessions[index];
        final bool isPresent = session['isPresent'];
        final bool isLocked = session['isLocked'];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPresent 
                ? const Color(0xFF4ADE80).withOpacity(0.5) 
                : (isDark ? Colors.white10 : Colors.grey.shade200),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isPresent 
                    ? const Color(0xFF4ADE80).withOpacity(0.2)
                    : (isLocked ? Colors.grey.withOpacity(0.2) : const Color(0xFF6366F1).withOpacity(0.1)),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${session['week']}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: isPresent 
                    ? const Color(0xFF16A34A) 
                    : (isLocked ? Colors.grey : const Color(0xFF6366F1)),
                ),
              ),
            ),
            title: Text(
              session['topic'],
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.grey.shade900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Status: ${isPresent ? 'Hadir' : (isLocked ? 'Belum Mulai' : 'Absen')}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isPresent ? const Color(0xFF16A34A) : Colors.grey,
              ),
            ),
            trailing: isLocked 
              ? const Icon(Icons.lock_outline, color: Colors.grey, size: 20)
              : Transform.scale(
                  scale: 1.1,
                  child: Checkbox(
                    value: isPresent,
                    activeColor: const Color(0xFF4ADE80),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    onChanged: (val) => _toggleAttendance(index),
                  ),
                ),
          ),
        ).animate().fadeIn(delay: (50 * index).ms).slideX();
      },
    );
  }

  // TAB 2: Statistik Kehadiran
  Widget _buildStatisticsTab(bool isDark) {
    double percentage = _calculateAttendancePercentage();
    int totalPresent = _sessions.where((s) => s['isPresent'] == true).length;
    int remaining = 16 - totalPresent;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Circular Progress Indicator Besar
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          height: 180,
                          width: 180,
                          child: CircularProgressIndicator(
                            value: percentage / 100,
                            strokeWidth: 16,
                            backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              percentage >= 75 ? const Color(0xFF4ADE80) : 
                              (percentage >= 50 ? Colors.orange : Colors.red),
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: GoogleFonts.poppins(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.grey.shade900,
                              ),
                            ),
                            Text(
                              'Kehadiran',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  percentage >= 75 
                    ? 'Bagus! Pertahankan kehadiranmu.'
                    : 'Hati-hati, kehadiranmu di bawah rata-rata.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ).animate().scale(),

          const SizedBox(height: 24),

          // Grid Summary
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Hadir',
                  count: '$totalPresent',
                  color: const Color(0xFF4ADE80),
                  icon: Icons.check_circle_outline,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Sisa/Absen',
                  count: '$remaining',
                  color: Colors.redAccent,
                  icon: Icons.cancel_outlined,
                  isDark: isDark,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
          
          const SizedBox(height: 16),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF6366F1)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Minimal kehadiran untuk mengikuti UAS adalah 75% (12 Pertemuan).',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.grey.shade900,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}