// lib/features/home/screen/start_meeting_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; //Impor Firebase Auth
import 'package:projek_akhir_edukasi/features/home/screen/meeting_screen.dart';

class StartMeetingScreen extends StatefulWidget {
  const StartMeetingScreen({Key? key}) : super(key: key);

  @override
  State<StartMeetingScreen> createState() => _StartMeetingScreenState();
}

class _StartMeetingScreenState extends State<StartMeetingScreen> {
  final User user = FirebaseAuth.instance.currentUser!;  //Ambil data user yang sedang login

  // Controller untuk nama, akan kita isi otomatis
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    //Isi otomatis nama user
    _nameController = TextEditingController(
      text: user.displayName ?? '', // Ambil nama dari Firebase
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Fungsi untuk MEMBUAT meeting baru
  void _startMeeting() {
    String name = _nameController.text.trim();
    String newMeetingID = (100000 + Random().nextInt(900000)).toString();

    if (name.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeetingScreen(
            meetingID: newMeetingID,
            // name: name, // TODO: Anda masih bisa teruskan nama jika perlu
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi Nama Anda')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Meeting'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Tampilkan Foto Profil
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              // Cek jika user punya foto (dari Google), jika tidak, tampilkan ikon
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : null,
              child: user.photoURL == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 24),
            // ---------------------------------------

            // Text field untuk Nama (sudah terisi otomatis)
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),
            // Tombol Start
            ElevatedButton(
              onPressed: _startMeeting,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.orange, // Warna oranye
                foregroundColor: Colors.white,
                 shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Start Meeting', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}