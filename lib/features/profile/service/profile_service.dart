import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan User ID saat ini
  String? get currentUserId => _auth.currentUser?.uid;

  // 1. Ambil Data User dari Firestore
  Stream<DocumentSnapshot> getUserStream() {
    if (currentUserId == null) return const Stream.empty();
    return _firestore.collection('users').doc(currentUserId).snapshots();
  }

  // 2. Simpan/Update Data User
  Future<void> updateUserProfile({
    required String fullName,
    required String nim,
    required String major,
    required String phone,
    required String bio,
  }) async {
    if (currentUserId == null) return;

    await _firestore.collection('users').doc(currentUserId).set({
      'fullName': fullName,
      'nim': nim,
      'major': major,
      'phone': phone,
      'bio': bio,
      'email': _auth.currentUser?.email, // Simpan email juga untuk referensi
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // merge: true agar tidak menimpa data lain
    
    // Update Display Name di Auth juga agar sinkron
    await _auth.currentUser?.updateDisplayName(fullName);
  }
}