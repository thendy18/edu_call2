import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projek_akhir_edukasi/features/resources/data/resource_model.dart';

class ResourceService {
  final CollectionReference _resourcesCollection =
      FirebaseFirestore.instance.collection('resources');

  // create materi baru
  Future<void> addResource({
    required String title,
    required String description,
    required String url,
    required String learningPlan,
    required String type,
  }) async {
    await _resourcesCollection.add({
      'title': title,
      'description': description,
      'url': url,
      'learningPlan': learningPlan,
      'type': type,
      'summary': '', // rangkuman awal kosong
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ambil data 
  Stream<List<ResourceModel>> getResources() {
    return _resourcesCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ResourceModel.fromSnapshot(doc);
      }).toList();
    });
  }

  // save rangkuman 
  Future<void> updateSummary(String id, String newSummary) async {
    await _resourcesCollection.doc(id).update({'summary': newSummary});
  }
  // delete materi 
  Future<void> deleteResource(String id) async {
    await _resourcesCollection.doc(id).delete();
  }
}