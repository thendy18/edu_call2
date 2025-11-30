import 'package:flutter/material.dart';

// -------------------- MODELS --------------------

// Model Jadwal Harian (Senin, Selasa, dll)
class ClassSchedule {
  final int dayOfWeek; // 1 = Senin, 7 = Minggu
  final String startTime;
  final String endTime;
  final String room;

  ClassSchedule(this.dayOfWeek, this.startTime, this.endTime, this.room);
}

// Model Sesi Pertemuan (Topik & Absensi)
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

// Model Mata Kuliah Utama
class CourseModel {
  final String id;
  final String code;
  final String name;
  final int sks;
  final String lecturer;
  final List<ClassSchedule> schedules;
  final Color color;
  final List<ClassSession> sessions; // Detail pertemuan

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

// -------------------- SERVICE --------------------

class AcademicService {
  // Singleton Pattern agar data konsisten di seluruh aplikasi
  static final AcademicService _instance = AcademicService._internal();
  factory AcademicService() => _instance;
  AcademicService._internal();

  // --- HELPER DATA GENERATOR (Untuk Absensi) ---
  
  // Data sesi spesifik untuk Computer Systems (Sesuai Gambar User)
// Helper untuk generate data sesi sesuai gambar user
  List<ClassSession> _generateComputerSystemSessions() {
    final topics = [
      'Sistem Bilangan',
      'Gerbang Logika dan Aljabar Boole',
      'Karnough Map',
      'Rangkaian Kombinatorial',
      'Rangkaian Sekuensial',
      'Register dan Counter',
      'Memori dan Review',
      'UTS (Ujian Tengah Semester)',
      'Basic Concept & Computer Evolution',
      'Performance Issues',
      'Computer Functions & Interconnections',
      'Memori: Characteristics & Cache Design',
      'Input/Output of Computer Systems',
      'Processor Structure and Functions'
    ];

    // TENTUKAN TANGGAL MULAI: 20 Agustus 2025
    DateTime startDate = DateTime(2025, 8, 20); 

    return List.generate(topics.length, (index) {
      // LOGIKA KALENDER: Tambahkan 7 hari dikali index pertemuan
      DateTime currentDate = startDate.add(Duration(days: index * 7));
      
      // FORMAT TANGGAL: dd/MM/yyyy (misal: 03/09/2025)
      String formattedDate = "${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}";

      return ClassSession(
        week: index + 1,
        date: formattedDate, // Menggunakan tanggal hasil perhitungan DateTime
        topic: topics[index],
        isPresent: index < 5, // Mock: 5 pertemuan awal sudah hadir
        isLocked: index > 7, // Mock: Pertemuan setelah UTS terkunci
      );
    });
  }

  // Data sesi spesifik untuk Front-End Programming (Sesuai Gambar Baru)
  List<ClassSession> _generateFrontEndSessions() {
    final topics = [
      'HTML',                                                                     // Minggu 1
      'CSS',                                                                      // Minggu 2
      'Javascript & DOM',                                                         // Minggu 3
      'Responsive Design',                                                        // Minggu 4
      'jQuery',                                                                   // Minggu 5
      'Bootstrap',                                                                // Minggu 6
      'Bootstrap Layout',                                                         // Minggu 7
      'UTS',                                                                      // Minggu 8
      'Instalasi React.js, Functional Components, Props, States',                 // Minggu 9
      'Nested File-Based Routing, Dynamic Routing, Input Form, Local Storage, Link', // Minggu 10 (Absen)
      'CSS, Global CSS, Bootstrap, Example Blog App',                             // Minggu 11
      'Public API, Database, Prisma',                                             // Minggu 12
      'Lanjutan Public API dan Database',                                         // Minggu 13
      'Kuis',                                                                     // Minggu 14
      'Deployment with Vercel'                                                    // Minggu 15
    ];

    // Start Date: 18 Agustus 2025 (Senin)
    DateTime startDate = DateTime(2025, 8, 18);

    return List.generate(topics.length, (index) {
      // 1. Logika Tanggal (Per minggu)
      DateTime currentDate = startDate.add(Duration(days: index * 7));
      String formattedDate = "${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}";

      // 2. Logika Absensi Sesuai Gambar
      // Minggu ke-10 (Index 9) user tidak hadir (X)
      bool isAbsentWeek = (index == 9); 

      return ClassSession(
        week: index + 1,
        date: formattedDate,
        topic: topics[index],
        isPresent: !isAbsentWeek, // Jika minggu ini absen, maka isPresent = false
        isLocked: false, 
      );
    });
  }

  // Data sesi default untuk mata kuliah lain
  List<ClassSession> _generateDefaultSessions() {
    return List.generate(14, (index) => ClassSession(
      week: index + 1,
      date: 'Minggu ke-${index + 1}',
      topic: 'Topik Pembahasan Minggu ${index + 1}',
      isPresent: false,
      isLocked: false,
    ));
  }

  // --- DATA UTAMA (ENROLLED COURSES) ---

  // List mata kuliah yang SEDANG diambil user
// --- DATA UTAMA (ENROLLED COURSES) ---

  late final List<CourseModel> enrolledCourses = [
    // 1. Computer Systems (Rabu & Kamis)
    CourseModel(
      id: '1',
      code: 'TK23016',
      name: 'Computer Systems',
      sks: 6,
      lecturer: 'Dr. Hugeng, M.T.',
      color: const Color(0xFFFF6B6B),
      schedules: [
        ClassSchedule(4, '07:30', '09:10', 'R0804'), // Kamis
        ClassSchedule(3, '09:30', '13:10', 'R0804'), // Rabu
      ],
      sessions: _generateComputerSystemSessions(),
    ),
    
    // 2. Intro to OS (Jumat)
    CourseModel(
      id: '2',
      code: 'TK23017',
      name: 'Intro to Operating Systems',
      sks: 4,
      lecturer: 'Ir. Yohanes Calvinus',
      color: const Color(0xFF4ECDC4),
      schedules: [
        ClassSchedule(5, '09:30', '11:10', 'R0706'), // Jumat
        ClassSchedule(5, '15:30', '17:10', 'R0706'),
      ],
      sessions: _generateDefaultSessions(),
    ),

    // 3. Mobile Programming (Rabu & Kamis)
    CourseModel(
      id: '3',
      code: 'TK23019',
      name: 'Mobile Programming',
      sks: 4,
      lecturer: 'Janson Hendryli, M.Kom.',
      color: const Color(0xFF6366F1),
      schedules: [
        ClassSchedule(3, '13:30', '15:10', 'R0806'), // Rabu
        ClassSchedule(4, '11:30', '13:10', 'R0806'), // Kamis
      ],
      sessions: _generateDefaultSessions(),
    ),

    // --- TAMBAHAN YANG HILANG (SENIN & SELASA) ---

    // 4. Front-End Programming (Senin)
    CourseModel(
      id: '4',
      code: 'TK23023',
      name: 'Front-End Programming',
      sks: 4,
      lecturer: 'Janson Hendryli, M.Kom.',
      color: const Color(0xFFFFA502),
      schedules: [
        ClassSchedule(1, '07:30', '09:10', 'R0805'), // Senin Pagi
        ClassSchedule(1, '09:30', '11:10', 'R0805'), // Senin Siang
      ],
      // UPDATE DISINI: Gunakan generator baru
      sessions: _generateFrontEndSessions(), 
    ),

    // 5. Distributed Systems (Selasa)
    CourseModel(
      id: '5',
      code: 'TK33010',
      name: 'Distributed Systems',
      sks: 4,
      lecturer: 'Lely Hiryanto, Ph.D.',
      color: const Color(0xFFA06CD5), // Ungu
      schedules: [
        ClassSchedule(2, '13:30', '15:10', 'R0702'), // Selasa Siang
        ClassSchedule(2, '15:30', '17:10', 'R0702'), // Selasa Sore
      ],
      sessions: _generateDefaultSessions(),
    ),
  ];

  // --- DATA KURSUS TERSEDIA (AVAILABLE COURSES - UNTUK KRS) ---
  // Ini yang sebelumnya hilang dan menyebabkan error
  late final List<CourseModel> availableCourses = [
    CourseModel(
      id: '4',
      code: 'TK4001',
      name: 'Artificial Intelligence',
      sks: 3,
      lecturer: 'Dr. Alan Turing',
      color: Colors.blueAccent,
      schedules: [ClassSchedule(1, '13:30', '15:30', 'LAB-AI')], // Senin
      sessions: _generateDefaultSessions(),
    ),
    CourseModel(
      id: '5',
      code: 'TK4002',
      name: 'Cloud Computing',
      sks: 3,
      lecturer: 'Satya Nadella, M.Cs',
      color: Colors.cyan,
      schedules: [ClassSchedule(2, '09:30', '11:30', 'R0900')], // Selasa
      sessions: _generateDefaultSessions(),
    ),
    CourseModel(
      id: '6',
      code: 'TK4003',
      name: 'Cyber Security',
      sks: 2,
      lecturer: 'Mr. Robot',
      color: Colors.redAccent,
      schedules: [ClassSchedule(5, '13:30', '15:10', 'LAB-SEC')], // Jumat
      sessions: _generateDefaultSessions(),
    ),
  ];

  // --- LOGIC METHODS (KRS & JADWAL) ---

  // 1. Hitung Total SKS (Memperbaiki error 'getTotalSKS')
  int getTotalSKS() {
    return enrolledCourses.fold(0, (sum, item) => sum + item.sks);
  }

  // 2. Tambah Mata Kuliah (Memperbaiki error 'addCourse')
  bool addCourse(CourseModel course) {
    // Cek SKS Max
    if (getTotalSKS() + course.sks > 24) { // Biasanya max 24
      return false; 
    }
    // Cek Duplicate
    if (enrolledCourses.any((c) => c.id == course.id)) {
      return false; 
    }
    
    enrolledCourses.add(course);
    return true;
  }

  // 3. Ambil Jadwal Harian (Untuk Kalender di Home)
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
    
    // Urutkan berdasarkan jam mulai
    dailySchedule.sort((a, b) {
      String timeA = (a['schedule'] as ClassSchedule).startTime;
      String timeB = (b['schedule'] as ClassSchedule).startTime;
      return timeA.compareTo(timeB);
    });

    return dailySchedule;
  }
}