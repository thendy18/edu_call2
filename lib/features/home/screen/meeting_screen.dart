import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek_akhir_edukasi/secrets.dart'; 
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class MeetingScreen extends StatelessWidget {
  // kita butu ID meeting untuk tahu harus join ke room mana
  final String meetingID;

  const MeetingScreen({
    super.key,
    required this.meetingID,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil data user yang sedang login
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting ID: $meetingID'),
      ),
      body: ZegoUIKitPrebuiltVideoConference(
        appID: zegoAppID, // <-- dari file secrets.dart
        appSign: zegoAppSign, // <-- dari file secrets.dart
        userID: user.uid, // ID unik user
        userName: user.displayName ?? 'User', // Nama user
        conferenceID: meetingID, // ID room yang mau di-join
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          // TODO: atur konfigurasinya di sini
          // Misalnya, matikan kamera/mic saat join
          // turnOnCameraWhenJoining: false,
          // turnOnMicrophoneWhenJoining: false,
        ),
      ),
    );
  }
}