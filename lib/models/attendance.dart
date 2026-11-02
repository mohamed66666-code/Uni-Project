class Attendance {
  final String courseName;
  final String courseCode;
  final String lectureTime;
  final String hall;
  final String doctorName;
  bool isPresent;
  DateTime? scannedAt;

  Attendance({
    required this.courseName,
    this.courseCode = '',
    required this.lectureTime,
    this.hall = '',
    this.doctorName = '',
    required this.isPresent,
    this.scannedAt,
  });
}
