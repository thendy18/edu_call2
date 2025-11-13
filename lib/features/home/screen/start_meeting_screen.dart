// lib/features/home/screen/start_meeting_screen.dart
import 'dart:io'; // Untuk File
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:firebase_storage/firebase_storage.dart'; // Import firebase_storage
import 'package:projek_akhir_edukasi/features/home/screen/meeting_screen.dart';

class StartMeetingScreen extends StatefulWidget {
  const StartMeetingScreen({super.key});

  @override
  State<StartMeetingScreen> createState() => _StartMeetingScreenState();
}

class _StartMeetingScreenState extends State<StartMeetingScreen> {
  final User user = FirebaseAuth.instance.currentUser!;

  late final TextEditingController _nameController;
  late final TextEditingController _meetingIdController;

  bool _isAnonymous = false;
  String _initials = '';
  // --- TAMBAHAN ---
  // Untuk menyimpan URL foto profil kustom yang sedang digunakan
  String? _customPhotoURL;
  // Untuk indikator loading saat mengunggah foto
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();

    String initialName = user.displayName ?? '';
    _nameController = TextEditingController(text: initialName);
    _initials = _getInitials(initialName);

    _meetingIdController = TextEditingController();
    _randomizeMeetingID();

    _nameController.addListener(_updateInitials);

    // --- TAMBAHAN ---
    // Inisialisasi customPhotoURL dengan photoURL dari Firebase Auth
    _customPhotoURL = user.photoURL;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _meetingIdController.dispose();
    _nameController.removeListener(_updateInitials);
    super.dispose();
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '';
    return name.trim()[0].toUpperCase();
  }

  void _updateInitials() {
    setState(() {
      _initials = _getInitials(_nameController.text);
    });
  }

  void _randomizeMeetingID() {
    String newMeetingID = (100000 + Random().nextInt(900000)).toString();
    _meetingIdController.text = newMeetingID;
  }

  // --- TAMBAHAN ---
  // Fungsi untuk memilih gambar dari galeri dan mengunggahnya
  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _isUploadingImage = true; // Mulai loading
      });
      try {
        final File file = File(image.path);
        final String fileName = '${user.uid}/profile_pic/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

        final UploadTask uploadTask = storageRef.putFile(file);
        final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        final String downloadURL = await snapshot.ref.getDownloadURL();

        // Update photoURL di Firebase Auth
        await user.updatePhotoURL(downloadURL);
        // Refresh user object untuk memastikan data terbaru
        await user.reload();
        // Update state customPhotoURL
        setState(() {
          _customPhotoURL = downloadURL;
          _isUploadingImage = false; // Hentikan loading
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diubah!')),
        );
      } catch (e) {
        setState(() {
          _isUploadingImage = false; // Hentikan loading jika error
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah foto: $e')),
        );
      }
    }
  }

  void _startMeeting() {
    String name = _nameController.text.trim();
    String meetingID = _meetingIdController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi Nama Anda')),
      );
      return;
    }
    if (meetingID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi Meeting ID')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeetingScreen(
          meetingID: meetingID,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- TAMBAHAN ---
      // AppBar dengan gradient ungu ke putih
      appBar: AppBar(
        title: const Text('Start Meeting'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.white], // Gradient ungu ke putih
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- MODIFIKASI ---
            // Tampilkan foto profil kustom, atau inisial jika anonymous
            GestureDetector( // Tambahkan GestureDetector untuk tap
              onTap: _isAnonymous ? null : _pickAndUploadImage, // Panggil fungsi ganti foto
              child: _isUploadingImage
                  ? const CircleAvatar(
                      radius: 50,
                      child: CircularProgressIndicator(), // Indikator loading
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: _isAnonymous
                          ? null // Jangan tampilkan gambar jika anonymous
                          : (_customPhotoURL != null
                              ? NetworkImage(_customPhotoURL!)
                              : null),
                      child: _isAnonymous
                          ? Text(
                              _initials,
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.purple[800], // Ubah warna inisial menjadi ungu
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : (_customPhotoURL == null
                              ? const Icon(Icons.person, size: 50)
                              : null),
                    ),
            ),
            const SizedBox(height: 12),

            SwitchListTile(
              title: const Text('Use Anonymous'),
              value: _isAnonymous,
              onChanged: (bool value) {
                setState(() {
                  _isAnonymous = value;
                });
              },
              activeThumbColor: Colors.purple, // Ubah warna switch menjadi ungu
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _meetingIdController,
              decoration: InputDecoration(
                labelText: 'Meeting ID',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(12),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _randomizeMeetingID,
                  tooltip: 'Generate Random ID',
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _startMeeting,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                // --- TAMBAHAN ---
                // Gradient pada tombol Start Meeting
                padding: EdgeInsets.zero, // Hapus padding default untuk gradient
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // Tambahkan Builder untuk menampilkan gradient di dalam tombol
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.white], // Gradient ungu ke putih
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 50),
                  child: const Text(
                    'Start Meeting',
                    style: TextStyle(fontSize: 16, color: Colors.black), // Ubah warna teks agar kontras dengan gradient
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}