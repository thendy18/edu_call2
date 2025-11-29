import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceModel {
  final String id;
  final String title;
  final String description;
  final String url;
  final String learningPlan;
  final String summary;
  final String type; // 'video', 'pdf', 'article'

  ResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.learningPlan,
    required this.summary,
    required this.type,
  });

  // Mengubah data dari Firestore menjadi Object Dart
  factory ResourceModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ResourceModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      url: data['url'] ?? '',
      learningPlan: data['learningPlan'] ?? '',
      summary: data['summary'] ?? '',
      type: data['type'] ?? 'article',
    );
  }
}