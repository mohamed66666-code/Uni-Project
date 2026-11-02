import 'dart:convert';

class AttendeeRecord {
  final String studentId;
  final String studentName;
  final String faculty;
  final DateTime timestamp;
  final String status;

  AttendeeRecord({
    required this.studentId,
    required this.studentName,
    required this.faculty,
    required this.timestamp,
    this.status = 'حاضر (مسح QR)',
  });

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'studentName': studentName,
        'faculty': faculty,
        'timestamp': timestamp.toIso8601String(),
        'status': status,
      };

  factory AttendeeRecord.fromJson(Map<String, dynamic> json) => AttendeeRecord(
        studentId: json['studentId'] ?? '',
        studentName: json['studentName'] ?? '',
        faculty: json['faculty'] ?? '',
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'])
            : DateTime.now(),
        status: json['status'] ?? 'حاضر (مسح QR)',
      );
}

class AttendanceSession {
  final String id;
  final String sessionCode;
  final String courseName;
  final String courseCode;
  final String doctorName;
  final String hall;
  final String sessionType; // 'محاضرة نظري' أو 'سكشن عملي'
  final DateTime createdAt;
  int durationMinutes;
  DateTime expiresAt;
  bool isActive;
  final List<AttendeeRecord> attendees;

  AttendanceSession({
    required this.id,
    required this.sessionCode,
    required this.courseName,
    required this.courseCode,
    required this.doctorName,
    required this.hall,
    required this.sessionType,
    required this.createdAt,
    required this.durationMinutes,
    required this.expiresAt,
    this.isActive = true,
    List<AttendeeRecord>? attendees,
  }) : attendees = attendees ?? [];

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Duration get remainingTime {
    if (isExpired || !isActive) return Duration.zero;
    return expiresAt.difference(DateTime.now());
  }

  String get qrPayload {
    return jsonEncode({
      'sessionId': id,
      'code': sessionCode,
      'courseCode': courseCode,
      'courseName': courseName,
      'doctor': doctorName,
      'hall': hall,
      'type': sessionType,
      'expiresAt': expiresAt.toIso8601String(),
    });
  }
}
