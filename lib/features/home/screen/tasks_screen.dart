// lib/features/home/screen/tasks_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// --- TAMBAHAN: Import halaman detail yang baru dibuat ---
import 'package:projek_akhir_edukasi/features/home/screen/task_detail_screen.dart';

// --- Model Task (Sama seperti sebelumnya) ---
class Task {
  String title;
  String description;
  DateTime? dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

// --- MODIFIKASI: StatefulWidget ---
class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

// --- MODIFIKASI: Tambahkan 'with TickerProviderStateMixin' untuk TabBar ---
class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  List<Task> _tasks = [];
  bool _isLoading = true;
  
  // --- TAMBAHAN: Controller untuk TabBar ---
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi TabController dengan 2 tab
    _tabController = TabController(length: 2, vsync: this);
    // Panggil fungsi untuk memuat data
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose(); // Jangan lupa dispose controller
    super.dispose();
  }

  // --- Fungsi _loadTasks dan _saveTasks (Sama seperti sebelumnya) ---
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tasksJson = prefs.getStringList('tasks') ?? [];
    setState(() {
      _tasks = tasksJson
          .map((taskString) => Task.fromJson(jsonDecode(taskString)))
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tasksJson =
        _tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  // --- MODIFIKASI: Fungsi _toggleTaskStatus sekarang menerima Objek Task ---
  void _toggleTaskStatus(Task taskToToggle) {
    // Cari index dari task yang ingin di-toggle
    final int index = _tasks.indexOf(taskToToggle);
    if (index == -1) return; // Tidak ketemu (seharusnya tidak terjadi)

    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _saveTasks(); // Simpan perubahan

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

  // --- MODIFIKASI: Fungsi _deleteTask sekarang menerima Objek Task ---
  // (Meskipun tidak dipakai di list, mungkin dipakai di detail nanti)
  void _deleteTask(Task taskToDelete) {
    final String deletedTaskTitle = taskToDelete.title;
    setState(() {
      _tasks.remove(taskToDelete);
    });
    _saveTasks(); // Simpan perubahan

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$deletedTaskTitle telah dihapus.'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  // --- Fungsi _showAddTaskDialog (Sama seperti sebelumnya) ---
  Future<void> _showAddTaskDialog() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    DateTime? selectedDate;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Tambah Tugas Baru'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration:
                            const InputDecoration(labelText: 'Judul Tugas'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: descController,
                        decoration:
                            const InputDecoration(labelText: 'Deskripsi'),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null
                                ? 'Pilih Batas Waktu (Opsional)'
                                : 'Batas Waktu: ${DateFormat('d MMM yyyy').format(selectedDate!)}',
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () async {
                              final DateTime? pickedDate =
                                  await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                setDialogState(() {
                                  selectedDate = pickedDate;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Simpan'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final Task newTask = Task(
                        title: titleController.text,
                        description: descController.text,
                        dueDate: selectedDate,
                        isCompleted: false,
                      );
                      setState(() {
                        _tasks.add(newTask);
                      });
                      _saveTasks();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    descController.dispose();
  }

  // --- TAMBAHAN: Fungsi untuk navigasi ke halaman detail ---
  void _navigateToDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          // Kirim fungsi _toggleTaskStatus ke halaman detail
          onStatusChanged: () => _toggleTaskStatus(task),
        ),
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
        // --- TAMBAHAN: Buat TabBar di bawah AppBar ---
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Belum Selesai'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      // --- MODIFIKASI: Body utama menggunakan TabBarView ---
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // --- Halaman 1: List Tugas Belum Selesai ---
                _buildTaskList(isCompleted: false),
                // --- Halaman 2: List Tugas Selesai ---
                _buildTaskList(isCompleted: true),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Tambah Tugas',
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- TAMBAHAN: Widget helper untuk membangun list tugas ---
  Widget _buildTaskList({required bool isCompleted}) {
    // Filter list tugas utama berdasarkan status
    final List<Task> filteredTasks =
        _tasks.where((task) => task.isCompleted == isCompleted).toList();

    // Tampilkan pesan jika list kosong
    if (filteredTasks.isEmpty) {
      return Center(
        child: Text(
          isCompleted ? 'Belum ada tugas yang selesai.' : 'Tidak ada tugas untuk sekarang.',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    // Bangun ListView
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];

        return TaskCard(
          task: task,
          // Tekan kartu -> buka detail
          onCardTap: () => _navigateToDetail(task),
          // Tekan tombol centang -> ubah status
          onToggleStatus: () => _toggleTaskStatus(task),
        );
      },
    );
  }
}

// --- MODIFIKASI: Widget TaskCard ---
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onCardTap; // Untuk klik seluruh kartu
  final VoidCallback onToggleStatus; // Untuk klik tombol centang

  const TaskCard({
    Key? key,
    required this.task,
    required this.onCardTap,
    required this.onToggleStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tentukan warna ikon berdasarkan status
    final Color iconColor = task.isCompleted ? Colors.green : Colors.grey[400]!;
    final IconData iconData = task.isCompleted
        ? Icons.check_circle
        : Icons.radio_button_unchecked;

    // Cek apakah sudah lewat batas waktu
    bool isOverdue = false;
    if (task.dueDate != null && !task.isCompleted) {
      isOverdue = task.dueDate!
          .isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    }

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // Gunakan InkWell untuk efek "splash" saat ditekan
      child: InkWell(
        onTap: onCardTap, // Klik di sini untuk ke detail
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Tombol Centang (Toggle Status) ---
              IconButton(
                icon: Icon(iconData, color: iconColor, size: 28),
                onPressed: onToggleStatus, // Klik di sini untuk ubah status
                padding: const EdgeInsets.only(right: 12.0),
                constraints: const BoxConstraints(),
              ),

              // --- Konten Utama (Judul, Deskripsi, Due Date) ---
              Expanded(
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
                      maxLines: 2, // Batasi deskripsi jadi 2 baris di list
                      overflow: TextOverflow.ellipsis,
                    ),

                    // --- Tampilkan Batas Waktu (Due Date) ---
                    if (task.dueDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: isOverdue ? Colors.red : Colors.grey[700],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Batas: ${DateFormat('d MMM yyyy').format(task.dueDate!)}',
                              style: TextStyle(
                                color: isOverdue ? Colors.red : Colors.grey[700],
                                fontStyle: FontStyle.italic,
                                fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // --- HILANGKAN CHIP STATUS & TOMBOL DELETE ---
                    // (Tidak perlu lagi karena sudah ada TabBar dan tombol centang)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}