import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnnouncementModel {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final int colorValue; // Menyimpan Color sebagai integer (0xFF...)

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.colorValue,
  });

  // Helper untuk mendapatkan objek Color
  Color get color => Color(colorValue);

  factory AnnouncementModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AnnouncementModel(
      id: doc.id,
      title: data['title'] ?? '',
      // Konversi Timestamp Firebase ke DateTime Dart
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      colorValue: data['colorValue'] ?? 0xFF2196F3, // Default Blue
    );
  }
}