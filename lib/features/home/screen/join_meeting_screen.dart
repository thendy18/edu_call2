// lib/features/home/screen/join_meeting_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; //Impor Firebase Auth
import 'package:projek_akhir_edukasi/features/home/screen/meeting_screen.dart'; 

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({Key? key}) : super(key: key);

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  final User user = FirebaseAuth.instance.currentUser!;   //Ambil data user yang sedang login

  final TextEditingController _meetingIdController = TextEditingController();
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
    _meetingIdController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Fungsi untuk bergabung ke meeting
  void _joinMeeting() {
    String meetingId = _meetingIdController.text.trim();
    String name = _nameController.text.trim();

    if (meetingId.isNotEmpty && name.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeetingScreen(
            meetingID: meetingId,
            // name: name, // TODO: Anda masih bisa teruskan nama jika perlu
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi Meeting ID dan Nama Anda')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Meeting'),
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
            
            // Text field untuk Meeting ID
            TextField(
              controller: _meetingIdController,
              decoration: const InputDecoration(
                labelText: 'Meeting Id',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
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
            // Tombol Join
            ElevatedButton(
              onPressed: _joinMeeting,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue.shade700, // Warna biru
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Join', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}