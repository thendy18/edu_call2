import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projek_akhir_edukasi/secrets.dart'; 
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class MeetingScreen extends StatelessWidget {
  final String meetingID;

  const MeetingScreen({
    super.key,
    required this.meetingID,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    // --- PERBAIKAN ALTERNATIF ---
    // Kita bungkus seluruh Scaffold-nya
    return SafeArea(
      top: false, // Kita sudah punya AppBar, jadi tidak perlu padding atas
      bottom: true, // Beri padding di bawah
      child: Scaffold(
        appBar: AppBar(
          title: Text('Meeting ID: $meetingID'),
        ),
        body: ZegoUIKitPrebuiltVideoConference(
          appID: zegoAppID,
          appSign: zegoAppSign,
          userID: user.uid,
          userName: user.displayName ?? 'User',
          conferenceID: meetingID,
          config: ZegoUIKitPrebuiltVideoConferenceConfig(
            turnOnCameraWhenJoining: true,
            turnOnMicrophoneWhenJoining: true,
          ),
        ),
      ),
    );
    // --- AKHIR PERBAIKAN ---
  }
}