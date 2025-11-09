// lib/features/home/screen/tasks_screen.dart
import 'package:flutter/material.dart';

// --- Model untuk menyimpan data tugas ---
class Task {
  final String title;
  final String description;
  bool isCompleted; 

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}

// --- Menggunakan StatefulWidget agar bisa interaktif ---
class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // --- Daftar Tugas Materi Kelas 12 ---
  final List<Task> _tasks = [
    Task(
      title: 'Tugas 1: Pahami Konsep Integral Tak Tentu',
      description: 'Pelajari dasar-dasar integral sebagai anti-turunan (kebalikan diferensial). '
                   'Lihat "Materi 1: Pengantar Integral" di halaman Materi.',
      isCompleted: false, 
    ),
    Task(
      title: 'Tugas 2: Kerjakan Latihan Soal Integral',
      description: 'Kerjakan 5 soal latihan dari buku paket halaman 82. '
                   'Gunakan "Materi 2: Rumus Dasar Integral" sebagai panduan.',
      isCompleted: false,
    ),
    Task(
      title: 'Tugas 3: Pahami Hukum Mendel',
      description: 'Pelajari tentang Hukum Segregasi dan Hukum Asortasi Bebas. '
                   'Lihat "Materi 3: Pengantar Genetika" di halaman Materi.',
      isCompleted: false,
    ),
    Task(
      title: 'Tugas 4: Latihan Persilangan Dihibrid',
      description: 'Buatlah diagram Punnett untuk persilangan dihibrid (dua sifat beda).',
      isCompleted: true, // Anggap ini sudah selesai
    ),
  ];

  // --- Fungsi untuk mengubah status tugas saat di-tap ---
  void _toggleTaskStatus(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _tasks[index].isCompleted
              ? '${_tasks[index].title} ditandai Selesai'
              : '${_tasks[index].title} ditandai Belum Selesai',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _tasks.length, 
        itemBuilder: (context, index) {
          final task = _tasks[index]; 
          
          return TaskCard(
            task: task, 
            onTap: () {
              _toggleTaskStatus(index);
            },
          );
        },
      ),
    );
  }
}

// --- Widget TaskCard (Sudah dinamis) ---
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap; 

  const TaskCard({
    Key? key,
    required this.task,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String status = task.isCompleted ? 'Selesai' : 'Belum Selesai';
    final Color statusColor = task.isCompleted ? Colors.green : Colors.orange;

    return InkWell(
      onTap: onTap, 
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2.0,
        margin: const EdgeInsets.only(bottom: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.description,
                style: TextStyle(
                  color: task.isCompleted ? Colors.grey[600] : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Chip(
                label: Text(status),
                backgroundColor: statusColor.withOpacity(0.2),
                labelStyle: TextStyle(color: statusColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}