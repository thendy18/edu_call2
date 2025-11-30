import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projek_akhir_edukasi/features/academic/data/course_data.dart';
import 'package:projek_akhir_edukasi/features/academic/screen/classes_screen.dart';
import 'package:projek_akhir_edukasi/features/meeting/meeting_screen.dart';
import 'package:projek_akhir_edukasi/features/meeting/start_meeting_screen.dart';
import 'package:projek_akhir_edukasi/features/tasks/screen/tasks_screen.dart';
import 'package:projek_akhir_edukasi/features/resources/screen/resources_screen.dart';
import 'package:projek_akhir_edukasi/features/academic/screen/class_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  final AcademicService _academicService = AcademicService();

  void _startNewMeeting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StartMeetingScreen(),
      ),
    );
  }

  // --- PERBAIKAN: Kode Dialog dimasukkan kembali ---
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
                            color: isDark ? Colors.white70 : Colors.grey.shade600),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade50,
                      ),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        labelStyle: TextStyle(
                            color: isDark ? Colors.white70 : Colors.grey.shade600),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade50,
                      ),
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.grey.shade700)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final meetingId = meetingIdController.text.trim();
                              if (meetingId.isNotEmpty) {
                                Navigator.pop(dialogContext);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MeetingScreen(meetingID: meetingId),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    final dailySchedules = _academicService.getScheduleForDay(_selectedDate.weekday);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  ).animate().fadeIn().slideX(),
                  const SizedBox(height: 8),
                  Text(
                    'Ready to learn today?',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                  ).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),

            _buildWeeklyCalendar(isDark),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      title: 'New Meeting',
                      icon: Icons.videocam,
                      gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
                      onTap: () => _startNewMeeting(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ActionCard(
                      title: 'Join Meeting',
                      icon: Icons.add_box_rounded,
                      isGlass: true,
                      onTap: () => _showJoinDialog(context),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      title: 'Tugas',
                      icon: Icons.assignment,
                      isGlass: true,
                      onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const TasksScreen())),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ActionCard(
                      title: 'Materi',
                      icon: Icons.topic,
                      isGlass: true,
                      onTap: () => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ResourcesScreen())),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jadwal: ${DateFormat('EEEE, d MMM').format(_selectedDate)}',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey.shade900),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const ClassesScreen())).then((_) {
                        setState(() {});
                      });
                    },
                    child: Text('KRS',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF6366F1), fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),

            if (dailySchedules.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.event_available,
                          size: 48, color: Colors.grey.withOpacity(0.5)),
                      const SizedBox(height: 8),
                      Text("Tidak ada kelas hari ini",
                          style: GoogleFonts.poppins(color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: dailySchedules.length,
                itemBuilder: (context, index) {
                  final item = dailySchedules[index];
                  final CourseModel course = item['course'];
                  final ClassSchedule schedule = item['schedule'];

                  return _ClassScheduleTile(
                    course: course,
                    schedule: schedule,
                  ).animate().fadeIn(delay: (100 * index).ms).slideX();
                },
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyCalendar(bool isDark) {
    DateTime now = DateTime.now();
    int currentDayOfWeek = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: currentDayOfWeek - 1));

    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime date = startOfWeek.add(Duration(days: index));
          bool isSelected =
              date.day == _selectedDate.day && date.month == _selectedDate.month;
          bool isToday = date.day == now.day && date.month == now.month;

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6366F1)
                    : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : (isToday
                          ? const Color(0xFF6366F1).withOpacity(0.5)
                          : Colors.transparent),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4))
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ClassScheduleTile extends StatelessWidget {
  final CourseModel course;
  final ClassSchedule schedule;

  const _ClassScheduleTile({required this.course, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassDetailScreen(course: course),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: course.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(schedule.startTime,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, color: course.color)),
                  Text("s/d",
                      style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey)),
                  Text(schedule.endTime,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, color: course.color)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.name,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87)),
                  Text("${course.code} • ${course.sks} SKS",
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(schedule.room,
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                      const SizedBox(width: 12),
                      Icon(Icons.person_outline, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(course.lecturer,
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey),
                              overflow: TextOverflow.ellipsis)),
                    ],
                  )
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

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

    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: gradient != null
                      ? Colors.white
                      : (isDark ? Colors.white : Colors.grey.shade800),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: gradient != null
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}