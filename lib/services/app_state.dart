import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/attendance.dart';
import '../models/attendance_session.dart';

class ScheduleLecture {
  final String day;
  final String courseName;
  final String courseCode;
  final String time;
  final String hall;
  final String doctor;
  final String type; // 'محاضرة' أو 'سكشن عملي'

  ScheduleLecture({
    required this.day,
    required this.courseName,
    required this.courseCode,
    required this.time,
    required this.hall,
    required this.doctor,
    required this.type,
  });
}

class CourseGrade {
  final String courseName;
  final String courseCode;
  final int creditHours;
  final int midterm;
  final int practical;
  final int finalExam;
  final int total;
  final String gradeLetter;
  final double points;

  CourseGrade({
    required this.courseName,
    required this.courseCode,
    required this.creditHours,
    required this.midterm,
    required this.practical,
    required this.finalExam,
    required this.total,
    required this.gradeLetter,
    required this.points,
  });
}

class DigitalBook {
  final String id;
  final String title;
  final String courseName;
  final String author;
  final String fileSize;
  final String category;
  bool isDownloaded;

  DigitalBook({
    required this.id,
    required this.title,
    required this.courseName,
    required this.author,
    required this.fileSize,
    required this.category,
    this.isDownloaded = false,
  });
}

class ExamItem {
  final String courseName;
  final String courseCode;
  final String date;
  final String time;
  final String duration;
  final String committeeHall;

  ExamItem({
    required this.courseName,
    required this.courseCode,
    required this.date,
    required this.time,
    required this.duration,
    required this.committeeHall,
  });
}

class StudentTicket {
  final String id;
  final String title;
  final String department;
  final String date;
  final String status; // 'قيد المراجعة' أو 'تم الرد'
  final String message;
  final String? reply;

  StudentTicket({
    required this.id,
    required this.title,
    required this.department,
    required this.date,
    required this.status,
    required this.message,
    this.reply,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color iconColor;
  final String? targetRoute;
  final String? routeLabel;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.targetRoute,
    this.routeLabel,
    this.isRead = false,
  });
}

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  factory AppState() => instance;

  AppState._internal() {
    _initDefaultStudent();
    _initDefaultData();
  }

  // --- Student & Auth ---
  Student? _currentStudent;
  Student? get currentStudent => _currentStudent;

  double _walletBalance = 2450.0;
  double get walletBalance => _walletBalance;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  final String _seatNumber = '10452';
  String get seatNumber => _seatNumber;

  final String _committeeNumber = 'لجنة 14 - مدرج 3';
  String get committeeNumber => _committeeNumber;

  void toggleDarkMode(bool val) {
    _isDarkMode = val;
    notifyListeners();
  }

  void topUpWallet(double amount) {
    _walletBalance += amount;
    notifyListeners();
  }

  bool deductFromWallet(double amount) {
    if (_walletBalance >= amount) {
      _walletBalance -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  void setStudent(Student student) {
    _currentStudent = student;
    notifyListeners();
  }

  void _initDefaultStudent() {
    _currentStudent = Student(
      id: '20241050',
      name: 'محمد عبد العال',
      email: 'mohamed.aal@stu.dmu.edu.eg',
      faculty: 'كلية الحاسبات والمعلومات',
      university: 'جامعة دمنهور',
    );
  }

  // --- Notifications ---
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'إعلان جدول امتحانات الميدتيرم',
      body: 'تم اعتماد جدول امتحانات منتصف الفصل الدراسي الأول 2026/2027.',
      time: 'منذ ساعتين',
      icon: Icons.assignment_outlined,
      iconColor: const Color(0xFF4F46E5),
      targetRoute: '/exams',
      routeLabel: 'جدول الامتحانات',
      isRead: false,
    ),
    AppNotification(
      id: '2',
      title: 'تم تسجيل الحضور بنجاح',
      body: 'تم تأكيد حضورك لمحاضرة هياكل البيانات والخوارزميات عبر رمز الـ QR.',
      time: 'اليوم 09:15 ص',
      icon: Icons.check_circle_outline,
      iconColor: const Color(0xFF10B981),
      targetRoute: '/attendance',
      routeLabel: 'سجل الحضور والـ QR',
      isRead: false,
    ),
    AppNotification(
      id: '3',
      title: 'خصم سداد رسوم دراسية',
      body: 'تم خصم 450 ج.م مقابل رسوم المنصة الإلكترونية وتوليد الإيصال.',
      time: 'أمس 02:40 م',
      icon: Icons.receipt_long_outlined,
      iconColor: const Color(0xFFF59E0B),
      targetRoute: '/payments',
      routeLabel: 'المحفظة والرسوم',
      isRead: true,
    ),
    AppNotification(
      id: '4',
      title: 'اعتماد نتائج الفصل الدراسي الأول',
      body: 'تم رصد درجات المواد والمعدل التراكمي CGPA، يمكنك طباعة النتيجة الآن.',
      time: 'منذ يومين',
      icon: Icons.grade_outlined,
      iconColor: const Color(0xFF6366F1),
      targetRoute: '/grades',
      routeLabel: 'النتائج والشهادة',
      isRead: false,
    ),
    AppNotification(
      id: '5',
      title: 'تحديث الجدول الدراسي الأسبوعي',
      body: 'تم تعديل قاعة سكشن قواعد البيانات إلى معمل 5 بمبنى التكنولوجيا.',
      time: 'منذ 3 أيام',
      icon: Icons.calendar_month_outlined,
      iconColor: const Color(0xFF0EA5E9),
      targetRoute: '/schedule',
      routeLabel: 'الجدول الدراسي',
      isRead: true,
    ),
    AppNotification(
      id: '6',
      title: 'كتاب دراسي جديد في المكتبة الرقمية',
      body: 'أتاح الدكتور أحمد الصاوي ملخص وسلايدات مادة هندسة البرمجيات.',
      time: 'منذ 4 أيام',
      icon: Icons.menu_book_outlined,
      iconColor: const Color(0xFFD97706),
      targetRoute: '/library',
      routeLabel: 'المكتبة الرقمية',
      isRead: true,
    ),
    AppNotification(
      id: '7',
      title: 'تم الرد على استفسارك الأكاديمي',
      body: 'قامت إدارة شؤون الطلاب بالرد على طلبك، اضغط لتفقد تفاصيل الرد.',
      time: 'منذ أسبوع',
      icon: Icons.support_agent_outlined,
      iconColor: const Color(0xFF7C3AED),
      targetRoute: '/inquiries',
      routeLabel: 'الشكاوى والطلبات',
      isRead: true,
    ),
  ];

  List<AppNotification> get notifications => _notifications;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    for (var n in _notifications) {
      if (n.id == id) {
        n.isRead = true;
        break;
      }
    }
    notifyListeners();
  }

  // --- Lecture Schedule ---
  final List<ScheduleLecture> _weeklySchedule = [
    ScheduleLecture(
      day: 'الأحد',
      courseName: 'هياكل البيانات والخوارزميات',
      courseCode: 'CS201',
      time: '09:00 ص - 11:00 ص',
      hall: 'مدرج 2 - الدور الثالث',
      doctor: 'د. سامح عبد الفتاح',
      type: 'محاضرة نظري',
    ),
    ScheduleLecture(
      day: 'الأحد',
      courseName: 'معمل هياكل البيانات',
      courseCode: 'CS201-Lab',
      time: '11:30 ص - 01:30 م',
      hall: 'معمل الحاسب 4',
      doctor: 'م. أحمد خالد (معيد)',
      type: 'سكشن عملي',
    ),
    ScheduleLecture(
      day: 'الإثنين',
      courseName: 'نظم إدارة قواعد البيانات',
      courseCode: 'IS202',
      time: '10:00 ص - 12:00 م',
      hall: 'قاعة 304 - مبنى ب',
      doctor: 'د. هناء إبراهيم',
      type: 'محاضرة نظري',
    ),
    ScheduleLecture(
      day: 'الإثنين',
      courseName: 'معمل قواعد البيانات SQL',
      courseCode: 'IS202-Lab',
      time: '12:30 م - 02:30 م',
      hall: 'معمل قواعد البيانات 2',
      doctor: 'م. سارة محمود (معيدة)',
      type: 'سكشن عملي',
    ),
    ScheduleLecture(
      day: 'الثلاثاء',
      courseName: 'هندسة البرمجيات المتقدمة',
      courseCode: 'SE301',
      time: '08:30 ص - 10:30 ص',
      hall: 'مدرج 1 - الدور الأرضي',
      doctor: 'د. أحمد الصاوي',
      type: 'محاضرة نظري',
    ),
    ScheduleLecture(
      day: 'الأربعاء',
      courseName: 'شبكات الحاسب والأمن السيبراني',
      courseCode: 'IT302',
      time: '09:00 ص - 11:00 ص',
      hall: 'قاعة السمينار 1',
      doctor: 'د. مصطفى الشريف',
      type: 'محاضرة نظري',
    ),
    ScheduleLecture(
      day: 'الخميس',
      courseName: 'الذكاء الاصطناعي وتعلم الآلة',
      courseCode: 'AI304',
      time: '11:00 ص - 01:00 م',
      hall: 'مدرج التكنولوجيا الرئيسي',
      doctor: 'د. رانيا عبد العزيز',
      type: 'محاضرة نظري',
    ),
  ];

  List<ScheduleLecture> get weeklySchedule => _weeklySchedule;

  // --- Grades & Transcript ---
  final List<CourseGrade> _courseGrades = [
    CourseGrade(
      courseName: 'هياكل البيانات والخوارزميات',
      courseCode: 'CS201',
      creditHours: 3,
      midterm: 19,
      practical: 20,
      finalExam: 56,
      total: 95,
      gradeLetter: 'A+',
      points: 4.0,
    ),
    CourseGrade(
      courseName: 'نظم إدارة قواعد البيانات',
      courseCode: 'IS202',
      creditHours: 3,
      midterm: 18,
      practical: 18,
      finalExam: 52,
      total: 88,
      gradeLetter: 'A',
      points: 3.7,
    ),
    CourseGrade(
      courseName: 'هندسة البرمجيات المتقدمة',
      courseCode: 'SE301',
      creditHours: 3,
      midterm: 16,
      practical: 19,
      finalExam: 47,
      total: 82,
      gradeLetter: 'B+',
      points: 3.3,
    ),
    CourseGrade(
      courseName: 'شبكات الحاسب والأمن السيبراني',
      courseCode: 'IT302',
      creditHours: 3,
      midterm: 17,
      practical: 18,
      finalExam: 50,
      total: 85,
      gradeLetter: 'A-',
      points: 3.5,
    ),
    CourseGrade(
      courseName: 'الذكاء الاصطناعي وتعلم الآلة',
      courseCode: 'AI304',
      creditHours: 3,
      midterm: 19,
      practical: 19,
      finalExam: 54,
      total: 92,
      gradeLetter: 'A',
      points: 3.8,
    ),
  ];

  List<CourseGrade> get courseGrades => _courseGrades;

  double get calculatedGpa {
    if (_courseGrades.isEmpty) return 0.0;
    double totalPoints = 0;
    int totalHours = 0;
    for (var g in _courseGrades) {
      totalPoints += g.points * g.creditHours;
      totalHours += g.creditHours;
    }
    return totalPoints / totalHours;
  }

  // --- Digital Library Books ---
  final List<DigitalBook> _digitalBooks = [
    DigitalBook(
      id: '1',
      title: 'Introduction to Algorithms (CLRS)',
      courseName: 'هياكل البيانات والخوارزميات',
      author: 'Thomas H. Cormen',
      fileSize: '18.4 MB',
      category: 'كتب دراسية',
    ),
    DigitalBook(
      id: '2',
      title: 'Database System Concepts (7th Edition)',
      courseName: 'نظم إدارة قواعد البيانات',
      author: 'Silberschatz & Korth',
      fileSize: '24.1 MB',
      category: 'كتب دراسية',
    ),
    DigitalBook(
      id: '3',
      title: 'ملخص محاضرات هندسة البرمجيات والتصميم المعماري',
      courseName: 'هندسة البرمجيات',
      author: 'أ.د. أحمد الصاوي',
      fileSize: '6.2 MB',
      category: 'مذكرات وسلايدات',
      isDownloaded: true,
    ),
    DigitalBook(
      id: '4',
      title: 'Computer Networking: A Top-Down Approach',
      courseName: 'شبكات الحاسب',
      author: 'Kurose & Ross',
      fileSize: '15.8 MB',
      category: 'كتب دراسية',
    ),
    DigitalBook(
      id: '5',
      title: 'Artificial Intelligence: A Modern Approach',
      courseName: 'الذكاء الاصطناعي',
      author: 'Stuart Russell',
      fileSize: '32.0 MB',
      category: 'كتب دراسية',
    ),
  ];

  List<DigitalBook> get digitalBooks => _digitalBooks;

  void toggleBookDownload(String bookId) {
    final book = _digitalBooks.firstWhere((b) => b.id == bookId);
    book.isDownloaded = !book.isDownloaded;
    notifyListeners();
  }

  // --- Exam Timetable ---
  final List<ExamItem> _examSchedule = [
    ExamItem(
      courseName: 'هياكل البيانات والخوارزميات',
      courseCode: 'CS201',
      date: 'السبت 10 يناير 2027',
      time: '09:00 ص - 11:00 ص',
      duration: 'ساعتان',
      committeeHall: 'مدرج 3 - لجنة 14',
    ),
    ExamItem(
      courseName: 'نظم إدارة قواعد البيانات',
      courseCode: 'IS202',
      date: 'الثلاثاء 13 يناير 2027',
      time: '09:00 ص - 11:00 ص',
      duration: 'ساعتان',
      committeeHall: 'مدرج 3 - لجنة 14',
    ),
    ExamItem(
      courseName: 'هندسة البرمجيات المتقدمة',
      courseCode: 'SE301',
      date: 'السبت 17 يناير 2027',
      time: '12:00 م - 02:00 م',
      duration: 'ساعتان',
      committeeHall: 'مدرج 2 - لجنة 8',
    ),
    ExamItem(
      courseName: 'شبكات الحاسب والأمن السيبراني',
      courseCode: 'IT302',
      date: 'الأربعاء 21 يناير 2027',
      time: '09:00 ص - 11:00 ص',
      duration: 'ساعتان',
      committeeHall: 'مدرج 3 - لجنة 14',
    ),
    ExamItem(
      courseName: 'الذكاء الاصطناعي وتعلم الآلة',
      courseCode: 'AI304',
      date: 'الأحد 25 يناير 2027',
      time: '09:00 ص - 11:00 ص',
      duration: 'ساعتان',
      committeeHall: 'مدرج التكنولوجيا - لجنة 1',
    ),
  ];

  List<ExamItem> get examSchedule => _examSchedule;

  // --- Student Tickets & Complaints ---
  final List<StudentTicket> _studentTickets = [
    StudentTicket(
      id: 'TK-8401',
      title: 'طلب تعديل قاعة سكشن قواعد البيانات',
      department: 'شؤون التعليم والطلاب',
      date: '14 أكتوبر 2026',
      status: 'تم الرد',
      message: 'نظراً لضيق معمل 2، نرجو نقل السكشن إلى معمل 5.',
      reply: 'تمت الموافقة وتم تعديل القاعة إلى معمل 5 بمبنى التكنولوجيا.',
    ),
    StudentTicket(
      id: 'TK-8402',
      title: 'استفسار عن موعد صرف بطاقة الدخول الذكية',
      department: 'شؤون الطلاب العامة',
      date: '17 أكتوبر 2026',
      status: 'قيد المراجعة',
      message: 'تقدمت بطلب استخراج بدل فاقد للكارنيه الذكي ولم أستلمه حتى الآن.',
    ),
  ];

  List<StudentTicket> get studentTickets => _studentTickets;

  void addTicket(String title, String department, String message) {
    final newTicket = StudentTicket(
      id: 'TK-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      title: title,
      department: department,
      date: 'اليوم',
      status: 'قيد المراجعة',
      message: message,
    );
    _studentTickets.insert(0, newTicket);
    notifyListeners();
  }

  // --- Attendance & QR Session State ---
  final List<Attendance> _attendanceRecords = [
    Attendance(
      courseName: 'هياكل البيانات والخوارزميات',
      courseCode: 'CS201',
      lectureTime: 'الأحد 09:00 ص - 11:00 ص',
      hall: 'مدرج 2 - الدور الثالث',
      doctorName: 'د. سامح عبد الفتاح',
      isPresent: true,
      scannedAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
    ),
    Attendance(
      courseName: 'نظم إدارة قواعد البيانات',
      courseCode: 'IS202',
      lectureTime: 'الإثنين 11:30 ص - 01:30 م',
      hall: 'معمل 5 - مبنى التكنولوجيا',
      doctorName: 'د. هناء إبراهيم',
      isPresent: true,
      scannedAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
    ),
    Attendance(
      courseName: 'هندسة البرمجيات المتقدمة',
      courseCode: 'SE301',
      lectureTime: 'الثلاثاء 10:00 ص - 12:00 م',
      hall: 'مدرج 1 - الدور الأرضي',
      doctorName: 'د. أحمد الصاوي',
      isPresent: false,
    ),
    Attendance(
      courseName: 'شبكات الحاسب والأمن السيبراني',
      courseCode: 'IT302',
      lectureTime: 'الأربعاء 08:30 ص - 10:30 ص',
      hall: 'معمل الشبكات 2',
      doctorName: 'د. مصطفى الشريف',
      isPresent: true,
      scannedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Attendance(
      courseName: 'الذكاء الاصطناعي وتعلم الآلة',
      courseCode: 'AI304',
      lectureTime: 'الخميس 12:00 م - 02:00 م',
      hall: 'قاعة السمينار الرئيسية',
      doctorName: 'د. رانيا عبد العزيز',
      isPresent: false,
    ),
  ];

  AttendanceSession? _activeAttendanceSession;
  final List<AttendanceSession> _pastSessions = [];

  List<Attendance> get attendanceRecords => _attendanceRecords;
  AttendanceSession? get activeAttendanceSession => _activeAttendanceSession;
  List<AttendanceSession> get pastSessions => _pastSessions;

  AttendanceSession createAttendanceSession({
    required String courseName,
    required String courseCode,
    required String doctorName,
    required String hall,
    String sessionType = 'محاضرة نظري',
    int durationMinutes = 10,
  }) {
    final now = DateTime.now();
    final randomCode = '${courseCode.replaceAll(RegExp(r'[^A-Za-z0-9]'), '')}-${1000 + (now.millisecondsSinceEpoch % 9000)}';
    
    final session = AttendanceSession(
      id: 'ATT-${now.millisecondsSinceEpoch}',
      sessionCode: randomCode,
      courseName: courseName,
      courseCode: courseCode,
      doctorName: doctorName,
      hall: hall,
      sessionType: sessionType,
      createdAt: now,
      durationMinutes: durationMinutes,
      expiresAt: now.add(Duration(minutes: durationMinutes)),
      isActive: true,
      attendees: [
        AttendeeRecord(
          studentId: '20241012',
          studentName: 'أحمد كريم ممدوح',
          faculty: 'حاسبات ومعلومات',
          timestamp: now.subtract(const Duration(seconds: 45)),
        ),
        AttendeeRecord(
          studentId: '20241033',
          studentName: 'مريم محمود إبراهيم',
          faculty: 'حاسبات ومعلومات',
          timestamp: now.subtract(const Duration(seconds: 20)),
        ),
        AttendeeRecord(
          studentId: '20241048',
          studentName: 'يوسف عمر سالم',
          faculty: 'حاسبات ومعلومات',
          timestamp: now.subtract(const Duration(seconds: 5)),
        ),
      ],
    );

    if (_activeAttendanceSession != null && _activeAttendanceSession!.isActive) {
      _activeAttendanceSession!.isActive = false;
      _pastSessions.insert(0, _activeAttendanceSession!);
    }

    _activeAttendanceSession = session;
    notifyListeners();
    return session;
  }

  void extendActiveSession(int additionalMinutes) {
    if (_activeAttendanceSession != null && _activeAttendanceSession!.isActive) {
      _activeAttendanceSession!.durationMinutes += additionalMinutes;
      _activeAttendanceSession!.expiresAt =
          _activeAttendanceSession!.expiresAt.add(Duration(minutes: additionalMinutes));
      notifyListeners();
    }
  }

  void endActiveAttendanceSession() {
    if (_activeAttendanceSession != null) {
      _activeAttendanceSession!.isActive = false;
      _pastSessions.insert(0, _activeAttendanceSession!);
      _activeAttendanceSession = null;
      notifyListeners();
    }
  }

  void addManualAttendeeToActiveSession(String studentName, String studentId) {
    if (_activeAttendanceSession == null || !_activeAttendanceSession!.isActive) return;
    
    // Check if already in attendees
    final exists = _activeAttendanceSession!.attendees.any((a) => a.studentId == studentId);
    if (!exists) {
      _activeAttendanceSession!.attendees.insert(
        0,
        AttendeeRecord(
          studentId: studentId,
          studentName: studentName,
          faculty: 'حاسبات ومعلومات',
          timestamp: DateTime.now(),
          status: 'حاضر (تسجيل يدوي)',
        ),
      );
      notifyListeners();
    }
  }

  AttendanceScanResult recordStudentAttendance(String rawInput, {Student? student}) {
    final curStudent = student ?? _currentStudent ?? Student(
      id: '20241050',
      name: 'محمد عبد العال',
      email: 'mohamed.aal@stu.dmu.edu.eg',
      faculty: 'كلية الحاسبات والمعلومات',
      university: 'جامعة دمنهور',
    );

    String? targetCourseCode;
    String? targetSessionCode;

    // Try parsing JSON payload from QR
    try {
      final decoded = jsonDecode(rawInput);
      if (decoded is Map<String, dynamic>) {
        targetCourseCode = decoded['courseCode'];
        targetSessionCode = decoded['code'];
      }
    } catch (_) {
      // Input was plain text or short code
      targetSessionCode = rawInput.trim();
    }

    // Check with active session first
    if (_activeAttendanceSession != null && _activeAttendanceSession!.isActive) {
      final sess = _activeAttendanceSession!;
      
      final matchesSession = (targetSessionCode != null &&
              sess.sessionCode.toLowerCase() == targetSessionCode.toLowerCase()) ||
          (targetCourseCode != null &&
              sess.courseCode.toLowerCase() == targetCourseCode.toLowerCase()) ||
          targetSessionCode == sess.id;

      if (matchesSession) {
        if (sess.isExpired) {
          return AttendanceScanResult(
            success: false,
            message: 'انتهت صلاحية جلسة الحضور لهذه المحاضرة! يرجى مراجعة الدكتور.',
            session: sess,
          );
        }

        final alreadyRegistered = sess.attendees.any((a) => a.studentId == curStudent.id);
        if (alreadyRegistered) {
          return AttendanceScanResult(
            success: false,
            message: 'لقد قمت بتسجيل الحضور لهذه المحاضرة بالفعل!',
            session: sess,
          );
        }

        // Add to active session attendees
        sess.attendees.insert(
          0,
          AttendeeRecord(
            studentId: curStudent.id,
            studentName: curStudent.name,
            faculty: curStudent.faculty,
            timestamp: DateTime.now(),
          ),
        );

        // Update student's course attendance list
        Attendance? matchedItem;
        for (var item in _attendanceRecords) {
          if (item.courseCode.toLowerCase() == sess.courseCode.toLowerCase() ||
              item.courseName == sess.courseName) {
            item.isPresent = true;
            item.scannedAt = DateTime.now();
            matchedItem = item;
            break;
          }
        }

        if (matchedItem == null) {
          matchedItem = Attendance(
            courseName: sess.courseName,
            courseCode: sess.courseCode,
            lectureTime: 'اليوم ${TimeOfDay.now().format(WidgetsBinding.instance.rootElement!)}',
            hall: sess.hall,
            doctorName: sess.doctorName,
            isPresent: true,
            scannedAt: DateTime.now(),
          );
          _attendanceRecords.insert(0, matchedItem);
        }

        // Add system notification
        _notifications.insert(
          0,
          AppNotification(
            id: 'att-${DateTime.now().millisecondsSinceEpoch}',
            title: 'تم تسجيل الحضور بنجاح 🎯',
            body: 'تم تأكيد حضورك في مقرر ${sess.courseName} مع ${sess.doctorName} بنجاح عبر مسح الـ QR.',
            time: 'الآن',
            icon: Icons.qr_code_scanner_rounded,
            iconColor: const Color(0xFF10B981),
            targetRoute: '/attendance',
            routeLabel: 'سجل الحضور والـ QR',
            isRead: false,
          ),
        );

        notifyListeners();

        return AttendanceScanResult(
          success: true,
          message: 'تم تأكيد حضورك بنجاح في مادة ${sess.courseName}!',
          session: sess,
          attendanceItem: matchedItem,
        );
      }
    }

    // If no active session matched, check if input matches any course code directly (smart fallback)
    for (var item in _attendanceRecords) {
      if (item.courseCode.toLowerCase() == (targetCourseCode ?? rawInput).toLowerCase() ||
          item.courseName.contains(rawInput.trim())) {
        item.isPresent = true;
        item.scannedAt = DateTime.now();

        _notifications.insert(
          0,
          AppNotification(
            id: 'att-${DateTime.now().millisecondsSinceEpoch}',
            title: 'تم تسجيل الحضور بنجاح 🎯',
            body: 'تم تأكيد حضورك في مقرر ${item.courseName} بنجاح.',
            time: 'الآن',
            icon: Icons.check_circle_outline,
            iconColor: const Color(0xFF10B981),
            targetRoute: '/attendance',
            routeLabel: 'سجل الحضور والـ QR',
            isRead: false,
          ),
        );

        notifyListeners();

        return AttendanceScanResult(
          success: true,
          message: 'تم تأكيد حضورك بنجاح في مقرر ${item.courseName}!',
          attendanceItem: item,
        );
      }
    }

    return AttendanceScanResult(
      success: false,
      message: 'رمز الـ QR غير صالح أو أن الجلسة لم تعد نشطة. تأكد من مسح الرمز الصحيح من شاشة المحاضر.',
    );
  }

  void _initDefaultData() {
    // Initialize an active session for demonstration so the teacher/student interaction works right away
    if (_activeAttendanceSession == null) {
      final now = DateTime.now();
      _activeAttendanceSession = AttendanceSession(
        id: 'ATT-DEMO-01',
        sessionCode: 'SE-3015',
        courseName: 'هندسة البرمجيات المتقدمة',
        courseCode: 'SE301',
        doctorName: 'د. أحمد الصاوي',
        hall: 'مدرج 1 - الدور الأرضي',
        sessionType: 'محاضرة نظري',
        createdAt: now.subtract(const Duration(minutes: 3)),
        durationMinutes: 15,
        expiresAt: now.add(const Duration(minutes: 12)),
        isActive: true,
        attendees: [
          AttendeeRecord(
            studentId: '20241005',
            studentName: 'محمود سامي العدوي',
            faculty: 'حاسبات ومعلومات',
            timestamp: now.subtract(const Duration(minutes: 2, seconds: 15)),
          ),
          AttendeeRecord(
            studentId: '20241021',
            studentName: 'سارة طارق المنشاوي',
            faculty: 'حاسبات ومعلومات',
            timestamp: now.subtract(const Duration(minutes: 1, seconds: 30)),
          ),
          AttendeeRecord(
            studentId: '20241038',
            studentName: 'عمر خالد الديب',
            faculty: 'حاسبات ومعلومات',
            timestamp: now.subtract(const Duration(seconds: 40)),
          ),
        ],
      );
    }
  }
}

class AttendanceScanResult {
  final bool success;
  final String message;
  final AttendanceSession? session;
  final Attendance? attendanceItem;

  AttendanceScanResult({
    required this.success,
    required this.message,
    this.session,
    this.attendanceItem,
  });
}
