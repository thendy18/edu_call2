import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_akhir_edukasi/features/academic/data/course_data.dart';

class ClassDetailScreen extends StatefulWidget {
  final CourseModel course;

  const ClassDetailScreen({super.key, required this.course});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ClassSession> _sessions;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Menggunakan referensi sesi dari course yang dipilih
    _sessions = widget.course.sessions;
  }

  void _toggleAttendance(int index) {
    if (_sessions[index].isLocked) return;
    setState(() {
      _sessions[index].isPresent = !_sessions[index].isPresent;
    });
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
            decoration: BoxDecoration(color: isDark ? Colors.black45 : Colors.white70, shape: BoxShape.circle),
            child: Icon(Icons.arrow_back_ios_new, size: 18, color: isDark ? Colors.white : Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detail Kelas', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(color: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA)),
        child: Column(
          children: [
            _buildHeader(isDark),
            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(color: widget.course.color, borderRadius: BorderRadius.circular(12)),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: const [Tab(text: 'Pertemuan'), Tab(text: 'Statistik')],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSessionList(isDark),
                  _buildStatistics(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Text(widget.course.name, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 8),
          Text("${widget.course.code} • ${widget.course.sks} SKS", style: GoogleFonts.poppins(color: Colors.grey)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: widget.course.color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(widget.course.lecturer, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: widget.course.color)),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _sessions.length,
      itemBuilder: (context, index) {
        final session = _sessions[index];
        // Warna baris selang-seling seperti di excel gambar user (opsional, tapi bagus untuk list panjang)
        final isEven = index % 2 == 0; 
        final bgColor = isEven 
            ? (isDark ? Colors.white.withOpacity(0.02) : Colors.grey.shade50)
            : Colors.transparent;

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            leading: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: session.isPresent ? const Color(0xFF4ADE80) : (isDark ? Colors.white10 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${session.week}",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: session.isPresent ? Colors.white : Colors.grey),
              ),
            ),
            title: Text(
              session.topic,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black87),
              maxLines: 2, overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              session.date, // Tanggal manual/mock
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
            trailing: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: session.isPresent,
                activeColor: widget.course.color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (val) => _toggleAttendance(index),
              ),
            ),
          ),
        ).animate().fadeIn(delay: (50 * index).ms);
      },
    );
  }

  Widget _buildStatistics(bool isDark) {
    int total = _sessions.length;
    int present = _sessions.where((s) => s.isPresent).length;
    double percentage = total == 0 ? 0 : (present / total);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Circular Progress
          SizedBox(
            height: 200, width: 200,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: 200, width: 200,
                    child: CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 20,
                      backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation(widget.course.color),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${(percentage * 100).toInt()}%", style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                      Text("Kehadiran", style: GoogleFonts.poppins(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().scale(),
          
          const SizedBox(height: 32),
          
          // Summary Cards
          Row(
            children: [
              Expanded(child: _statCard("Hadir", "$present Sesi", const Color(0xFF4ADE80), Icons.check_circle_outline, isDark)),
              const SizedBox(width: 16),
              Expanded(child: _statCard("Absen/Sisa", "${total - present} Sesi", Colors.redAccent, Icons.cancel_outlined, isDark)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, Color color, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}