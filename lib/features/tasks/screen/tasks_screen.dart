// lib/features/home/screen/tasks_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Tidak ada import untuk task_detail_screen.dart

// --- BAGIAN 1: MODEL DATA ---
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

// --- BAGIAN 2: LAYAR UTAMA (LIST TUGAS) ---
class TasksScreen extends StatefulWidget {
  // --- PERBAIKAN: Menggunakan super.key ---
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  List<Task> _tasks = [];
  bool _isLoading = true;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Fungsi Load/Save ---
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

  // --- Fungsi Aksi (Toggle/Delete) ---
  void _toggleTaskStatus(Task taskToToggle) {
    final int index = _tasks.indexOf(taskToToggle);
    if (index == -1) return;

    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _saveTasks();

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

  // --- Fungsi Delete (Dipakai di Tab Selesai) ---
  void _deleteTask(Task taskToDelete) {
    final String deletedTaskTitle = taskToDelete.title;
    setState(() {
      _tasks.remove(taskToDelete);
    });
    _saveTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$deletedTaskTitle telah dihapus.'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  // --- Fungsi Dialog Tambah Tugas (Perbaikan Context Versi FINAL) ---
  Future<void> _showAddTaskDialog() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    DateTime? selectedDate;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext statefulBuilderContext, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Tambah Tugas Baru'),
              content: Builder(builder: (BuildContext contentContext) {
                return Form(
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
                                  context: contentContext,
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
                );
              }),
              actions: [
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
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
                      Navigator.of(dialogContext).pop();
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

  // --- Fungsi Navigasi ke Detail ---
  void _navigateToDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          onStatusChanged: () => _toggleTaskStatus(task),
        ),
      ),
    );
  }

  // --- Widget Build (Badan Utama) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Belum Selesai'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(isCompleted: false),
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

  // --- Widget Helper Build Task List ---
  Widget _buildTaskList({required bool isCompleted}) {
    final List<Task> filteredTasks =
        _tasks.where((task) => task.isCompleted == isCompleted).toList();

    if (filteredTasks.isEmpty) {
      return Center(
        child: Text(
          isCompleted ? 'Belum ada tugas yang selesai.' : 'Tidak ada tugas untuk sekarang.',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];

        return TaskCard(
          task: task,
          onCardTap: () => _navigateToDetail(task),
          onToggleStatus: () => _toggleTaskStatus(task),
          // --- INI LOGIKA DELETE YANG DIMINTA ---
          onDelete: isCompleted ? () => _deleteTask(task) : null,
        );
      },
    );
  }
}

// --- BAGIAN 3: LAYAR DETAIL TUGAS ---
class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final VoidCallback onStatusChanged;

  // --- PERBAIKAN: Menggunakan super.key ---
  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            Text(
              task.title,
              style: TextStyle(
                fontSize: 24,
                // --- PERBAIKAN 1/4 ---
                fontWeight: FontWeight.bold, 
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 16),
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
            Text(
              'Deskripsi Tugas:',
              style: TextStyle(
                fontSize: 16,
                // --- PERBAIKAN 2/4 ---
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
            Text(
              'Lampiran:',
              style: TextStyle(
                fontSize: 16,
                // --- PERBAIKAN 3/4 ---
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
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  onStatusChanged();
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

// --- BAGIAN 4: WIDGET KARTU TUGAS ---
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onCardTap;
  final VoidCallback onToggleStatus;
  final VoidCallback? onDelete; // Opsional, untuk tombol delete

  // --- PERBAIKAN: Menggunakan super.key ---
  const TaskCard({
    super.key,
    required this.task,
    required this.onCardTap,
    required this.onToggleStatus,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = task.isCompleted ? Colors.green : Colors.grey[400]!;
    final IconData iconData = task.isCompleted
        ? Icons.check_circle
        : Icons.radio_button_unchecked;

    bool isOverdue = false;
    if (task.dueDate != null && !task.isCompleted) {
      isOverdue = task.dueDate!
          .isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    }

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onCardTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(iconData, color: iconColor, size: 28),
                onPressed: onToggleStatus,
                padding: const EdgeInsets.only(right: 12.0),
                constraints: const BoxConstraints(),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18,
                        // --- PERBAIKAN 4/4 ---
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                  ],
                ),
              ),
              // --- INI LOGIKA DELETE YANG DIMINTA ---
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red[700],
                  tooltip: 'Hapus Tugas',
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}