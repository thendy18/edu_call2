// lib/features/home/screen/home_screen.dart
import 'package:flutter/material.dart';
// Impor 4 halaman kita
import 'package:projek_akhir_edukasi/features/home/screen/join_meeting_screen.dart';
import 'package:projek_akhir_edukasi/features/home/screen/start_meeting_screen.dart';
import 'package:projek_akhir_edukasi/features/home/screen/tasks_screen.dart';      
import 'package:projek_akhir_edukasi/features/home/screen/resources_screen.dart';  

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // TOMBOL MEET
                _HomeButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartMeetingScreen(),
                      ),
                    );
                  },
                  icon: Icons.videocam,
                  text: 'Meet',
                  color: Colors.orange,
                ),
                // TOMBOL JOIN
                _HomeButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JoinMeetingScreen(),
                      ),
                    );
                  },
                  icon: Icons.add_box_rounded,
                  text: 'Join',
                  color: Colors.blue.shade700,
                ),
                _HomeButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TasksScreen(),
                      ),
                    );
                  },
                  icon: Icons.assignment, 
                  text: 'Tugas',           
                  color: Colors.blue.shade700,
                ),
                _HomeButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResourcesScreen(),
                      ),
                    );
                  },
                  icon: Icons.topic,  
                  text: 'Materi',   
                  color: Colors.blue.shade700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget kustom untuk tombol ikon
class _HomeButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String text;
  final Color color;

  const _HomeButton({
    required this.onTap,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}