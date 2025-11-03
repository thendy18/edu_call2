// lib/features/home/screen/home_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:projek_akhir_edukasi/features/home/screen/meeting_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Controller untuk menyimpan ID yang diketik user (untuk Join Meeting)
  final TextEditingController _meetingIDController = TextEditingController();

  // Fungsi untuk Start Meeting BARU (membuat ID acak)
  void _startNewMeeting() {
    // Buat ID acak 6 digit
    String newMeetingID = (100000 + Random().nextInt(900000)).toString();

    // Pindah ke halaman meeting
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeetingScreen(meetingID: newMeetingID),
      ),
    );
  }

  // Fungsi untuk Join Meeting 
  void _joinMeeting() {

    // Ambil ID dari text field, hilangkan spasi
    String meetingID = _meetingIDController.text.trim();

    if (meetingID.isNotEmpty) {
      // Pindah ke halaman meeting dengan ID yang diketik user
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeetingScreen(meetingID: meetingID),
        ),
      );
    } else {
      // peringatan jika ID kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan Meeting ID')),
      );
    }
  }

  // Hapus controller saat widget tidak dipakai agar tidak terjadi memory leak
  @override
  void dispose() {
    _meetingIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tombol Start Meeting
          _MeetingButton(
            onPressed: _startNewMeeting, 
            text: 'Start New Meeting',
            icon: Icons.videocam,
          ),

          const SizedBox(height: 20),

          // INPUT FIELD UNTUK JOIN MEETING 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: _meetingIDController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Meeting ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // ----------------------------------------------------

          // Tombol Join Meeting
          _MeetingButton(
            onPressed: _joinMeeting, 
            text: 'Join Meeting',
            icon: Icons.add_box_rounded,
          ),
        ],
      ),
    );
  }
}

// widget kustom untuk tombol 
class _MeetingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const _MeetingButton({
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(text, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
