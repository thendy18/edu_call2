import 'package:cloud_firestore/cloud_firestore.dart';
import 'announcement_model.dart';

class AnnouncementService {
  final CollectionReference _ref = FirebaseFirestore.instance.collection('announcements');

  Stream<List<AnnouncementModel>> getAnnouncements() {
    return _ref
        .orderBy('date', descending: true) 
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AnnouncementModel.fromSnapshot(doc))
            .toList());
  }

  Future<void> addAnnouncement({
    required String title,
    required String description,
    required int colorValue,
  }) async {
    await _ref.add({
      'title': title,
      'description': description,
      'date': FieldValue.serverTimestamp(), 
      'colorValue': colorValue,
    });
  }

  Future<void> deleteAnnouncement(String id) async {
    await _ref.doc(id).delete();
  }
}