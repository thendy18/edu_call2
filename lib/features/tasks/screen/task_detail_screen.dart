// lib/features/home/screen/task_detail_screen.dart
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import model Task dari file tasks_screen.dart
import 'package:projek_akhir_edukasi/features/tasks/screen/tasks_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  // Fungsi ini akan dikirim dari halaman sebelumnya
  final VoidCallback onStatusChanged; 

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Cek apakah sudah lewat batas waktu
    bool isOverdue = false;
    if (task.dueDate != null && !task.isCompleted) {
      isOverdue = task.dueDate!
          .isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- JUDUL TUGAS ---
            Text(
              task.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 16),

            // --- BATAS WAKTU (DUE DATE) ---
            if (task.dueDate != null)
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isOverdue ? Colors.red : Colors.grey[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Batas Waktu: ${DateFormat('d MMMM yyyy').format(task.dueDate!)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: isOverdue ? Colors.red : Colors.grey[700],
                      fontStyle: FontStyle.italic,
                      fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            const Divider(height: 30, thickness: 1),

            // --- DESKRIPSI ---
            Text(
              'Deskripsi Tugas:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.description.isEmpty ? '(Tidak ada deskripsi)' : task.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // --- BAGIAN LAMPIRAN (UNTUK NANTI) ---
            Text(
              'Lampiran:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add_photo_alternate_outlined, color: Colors.grey),
                  SizedBox(width: 12),
                  Text(
                    'Tambah foto (Fitur akan datang)',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const Spacer(), // Mendorong tombol ke bawah

            // --- TOMBOL AKSI (SELESAI/BATALKAN) ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Panggil fungsi yang dikirim dari halaman list
                  onStatusChanged();
                  // Tutup halaman detail setelah status diubah
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: task.isCompleted ? Colors.grey : Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  task.isCompleted ? 'Tandai Belum Selesai' : 'Tandai Selesai',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}