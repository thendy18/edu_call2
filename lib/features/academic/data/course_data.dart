import 'package:flutter/material.dart';

// -------------------- models --------------------

class ClassSchedule {
  final int dayOfWeek; // 1 = senin, 7 = minggu
  final String startTime;
  final String endTime;
  final String room;

  ClassSchedule(this.dayOfWeek, this.startTime, this.endTime, this.room);
}

class ClassSession {
  final int week;
  final String date;
  final String topic;
  bool isPresent;
  bool isLocked;

  ClassSession({
    required this.week,
    required this.date,
    required this.topic,
    this.isPresent = false,
    this.isLocked = false,
  });
}

class CourseModel {
  final String id;
  final String code;
  final String name;
  final int sks;
  final String lecturer;
  final List<ClassSchedule> schedules;
  final Color color;
  final List<ClassSession> sessions;

  CourseModel({
    required this.id,
    required this.code,
    required this.name,
    required this.sks,
    required this.lecturer,
    required this.schedules,
    required this.color,
    required this.sessions,
  });
}

// -------------------- service --------------------

class AcademicService {
  static final AcademicService _instance = AcademicService._internal();
  factory AcademicService() => _instance;
  
  AcademicService._internal() {
    // inisialisasi enrolled courses dengan 5 mata kuliah wajib
    // kita mengambil referensi dari _mastercourses agar datanya konsisten
    enrolledCourses.addAll([
      _masterCourses[0], // computer systems
      _masterCourses[1], // intro to os
      _masterCourses[2], // mobile programming
      _masterCourses[3], // front-end
      _masterCourses[4], // distributed systems
    ]);
  }

  // --- helper data generator ---
  
  List<ClassSession> _generateComputerSystemSessions() {
    final topics = [
      'Sistem Bilangan', 'Gerbang Logika dan Aljabar Boole', 'Karnough Map',
      'Rangkaian Kombinatorial', 'Rangkaian Sekuensial', 'Register dan Counter',
      'Memori dan Review', 'UTS (Ujian Tengah Semester)', 'Basic Concept & Computer Evolution',
      'Performance Issues', 'Computer Functions & Interconnections', 
      'Memori: Characteristics & Cache Design', 'Input/Output of Computer Systems',
      'Processor Structure and Functions'
    ];
    DateTime startDate = DateTime(2025, 8, 20); 
    return List.generate(topics.length, (index) {
      DateTime currentDate = startDate.add(Duration(days: index * 7));
      String formattedDate = "${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}";
      return ClassSession(week: index + 1, date: formattedDate, topic: topics[index], isPresent: index < 5, isLocked: index > 7);
    });
  }

  List<ClassSession> _generateFrontEndSessions() {
    final topics = [
      'HTML', 'CSS', 'Javascript & DOM', 'Responsive Design', 'jQuery', 'Bootstrap',
      'Bootstrap Layout', 'UTS', 'Instalasi React.js, Functional Components',
      'Nested File-Based Routing', 'CSS, Global CSS, Bootstrap', 
      'Public API, Database, Prisma', 'Lanjutan Public API dan Database', 'Kuis', 'Deployment with Vercel'
    ];
    DateTime startDate = DateTime(2025, 8, 18);
    return List.generate(topics.length, (index) {
      DateTime currentDate = startDate.add(Duration(days: index * 7));
      String formattedDate = "${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}";
      bool isAbsentWeek = (index == 9); // minggu ke-10 (index 9) absen
      return ClassSession(week: index + 1, date: formattedDate, topic: topics[index], isPresent: !isAbsentWeek, isLocked: false);
    });
  }

  List<ClassSession> _generateDefaultSessions() {
    return List.generate(14, (index) => ClassSession(
      week: index + 1,
      date: 'Minggu ke-${index + 1}',
      topic: 'Topik Pembahasan Minggu ${index + 1}',
      isPresent: false,
      isLocked: false,
    ));
  }

  // --- master data (semua mata kuliah yang ada di kampus) ---
  late final List<CourseModel> _masterCourses = [
    // 1. computer systems
    CourseModel(
      id: '1',
      code: 'TK23016',
      name: 'Computer Systems',
      sks: 6,
      lecturer: 'Dr. Hugeng, M.T.',
      color: const Color(0xFFFF6B6B),
      schedules: [
        ClassSchedule(4, '07:30', '09:10', 'R0804'),
        ClassSchedule(3, '09:30', '13:10', 'R0804'),
      ],
      sessions: _generateComputerSystemSessions(),
    ),
    // 2. intro to os
    CourseModel(
      id: '2',
      code: 'TK23017',
      name: 'Intro to Operating Systems',
      sks: 4,
      lecturer: 'Ir. Yohanes Calvinus',
      color: const Color(0xFF4ECDC4),
      schedules: [
        ClassSchedule(5, '09:30', '11:10', 'R0706'),
        ClassSchedule(5, '15:30', '17:10', 'R0706'),
      ],
      sessions: _generateDefaultSessions(),
    ),
    // 3. mobile programming
    CourseModel(
      id: '3',
      code: 'TK23019',
      name: 'Mobile Programming',
      sks: 4,
      lecturer: 'Janson Hendryli, M.Kom.',
      color: const Color(0xFF6366F1),
      schedules: [
        ClassSchedule(3, '13:30', '15:10', 'R0806'),
        ClassSchedule(4, '11:30', '13:10', 'R0806'),
      ],
      sessions: _generateDefaultSessions(),
    ),
    // 4. front-end programming
    CourseModel(
      id: '4',
      code: 'TK23023',
      name: 'Front-End Programming',
      sks: 4,
      lecturer: 'Janson Hendryli, M.Kom.',
      color: const Color(0xFFFFA502),
      schedules: [
        ClassSchedule(1, '07:30', '09:10', 'R0805'),
        ClassSchedule(1, '09:30', '11:10', 'R0805'),
      ],
      sessions: _generateFrontEndSessions(),
    ),
    // 5. distributed systems
    CourseModel(
      id: '5',
      code: 'TK33010',
      name: 'Distributed Systems',
      sks: 4,
      lecturer: 'Lely Hiryanto, Ph.D.',
      color: const Color(0xFFA06CD5),
      schedules: [
        ClassSchedule(2, '13:30', '15:10', 'R0702'),
        ClassSchedule(2, '15:30', '17:10', 'R0702'),
      ],
      sessions: _generateDefaultSessions(),
    ),
    // 6. artificial intelligence (pilihan)
    CourseModel(
      id: '6',
      code: 'TK4001',
      name: 'Artificial Intelligence',
      sks: 3,
      lecturer: 'Dr. Alan Turing',
      color: Colors.blueAccent,
      schedules: [ClassSchedule(1, '13:30', '15:30', 'LAB-AI')],
      sessions: _generateDefaultSessions(),
    ),
    // 7. cloud computing (pilihan)
    CourseModel(
      id: '7',
      code: 'TK4002',
      name: 'Cloud Computing',
      sks: 3,
      lecturer: 'Satya Nadella, M.Cs',
      color: Colors.cyan,
      schedules: [ClassSchedule(2, '09:30', '11:30', 'R0900')],
      sessions: _generateDefaultSessions(),
    ),
    // 8. cyber security (pilihan)
    CourseModel(
      id: '8',
      code: 'TK4003',
      name: 'Cyber Security',
      sks: 2,
      lecturer: 'Mr. Robot',
      color: Colors.redAccent,
      schedules: [ClassSchedule(5, '13:30', '15:10', 'LAB-SEC')],
      sessions: _generateDefaultSessions(),
    ),
  ];

  // --- state management ---

  // list yang sedang diambil mahasiswa
  final List<CourseModel> enrolledCourses = [];

  // getter: menampilkan semua course dari master data untuk list pilihan
  // ui akan menangani logika tombol "ambil" vs "diambil"
  List<CourseModel> get availableCourses => _masterCourses;

  // --- logic methods ---

  int getTotalSKS() {
    return enrolledCourses.fold(0, (sum, item) => sum + item.sks);
  }

  // tambah kelas: cek duplikasi dan sks
  bool addCourse(CourseModel course) {
    if (getTotalSKS() + course.sks > 24) return false;
    // cek apakah id sudah ada di enrolledcourses
    if (enrolledCourses.any((c) => c.id == course.id)) return false;
    
    enrolledCourses.add(course);
    return true;
  }

  // hapus kelas: hapus dari enrolledcourses saja, di _mastercourses tetap ada
  void removeCourse(String courseId) {
    enrolledCourses.removeWhere((course) => course.id == courseId);
  }

  // ambil jadwal harian untuk home screen
  List<Map<String, dynamic>> getScheduleForDay(int dayOfWeek) {
    List<Map<String, dynamic>> dailySchedule = [];
    
    for (var course in enrolledCourses) {
      for (var schedule in course.schedules) {
        if (schedule.dayOfWeek == dayOfWeek) {
          dailySchedule.add({
            'course': course,
            'schedule': schedule,
          });
        }
      }
    }
    
    dailySchedule.sort((a, b) {
      String timeA = (a['schedule'] as ClassSchedule).startTime;
      String timeB = (b['schedule'] as ClassSchedule).startTime;
      return timeA.compareTo(timeB);
    });

    return dailySchedule;
  }
}