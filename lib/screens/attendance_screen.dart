import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/attendance.dart';
import '../models/attendance_session.dart';
import '../services/app_state.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  int _portalModeIndex = 0; // 0: بوابة الطالب, 1: بوابة المحاضر
  int _studentFilterIndex = 0; // 0: الكل, 1: حاضر, 2: غائب
  Timer? _sessionCountdownTimer;

  // Teacher Creation Form State
  String _selectedCourseName = 'هندسة البرمجيات المتقدمة';
  String _selectedCourseCode = 'SE301';
  String _doctorName = 'د. أحمد الصاوي';
  String _hall = 'مدرج 1 - الدور الأرضي';
  String _sessionType = 'محاضرة نظري';
  int _durationMinutes = 15;

  final List<Map<String, String>> _availableCourses = [
    {
      'name': 'هياكل البيانات والخوارزميات',
      'code': 'CS201',
      'doctor': 'د. سامح عبد الفتاح',
      'hall': 'مدرج 2 - الدور الثالث',
    },
    {
      'name': 'نظم إدارة قواعد البيانات',
      'code': 'IS202',
      'doctor': 'د. هناء إبراهيم',
      'hall': 'معمل 5 - مبنى التكنولوجيا',
    },
    {
      'name': 'هندسة البرمجيات المتقدمة',
      'code': 'SE301',
      'doctor': 'د. أحمد الصاوي',
      'hall': 'مدرج 1 - الدور الأرضي',
    },
    {
      'name': 'شبكات الحاسب والأمن السيبراني',
      'code': 'IT302',
      'doctor': 'د. مصطفى الشريف',
      'hall': 'معمل الشبكات 2',
    },
    {
      'name': 'الذكاء الاصطناعي وتعلم الآلة',
      'code': 'AI304',
      'doctor': 'د. رانيا عبد العزيز',
      'hall': 'قاعة السمينار الرئيسية',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Ticking timer for active session remaining time updates
    _sessionCountdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final active = AppState.instance.activeAttendanceSession;
      if (active != null && active.isActive) {
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _sessionCountdownTimer?.cancel();
    super.dispose();
  }

  // --- Student Actions ---

  void _openQrScanner({String? prefillCode}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _QrScannerSheet(
        prefillCode: prefillCode,
        onScanned: (code) {
          Navigator.pop(ctx);
          _processAttendanceCode(code);
        },
      ),
    );
  }

  void _processAttendanceCode(String code) {
    final result = AppState.instance.recordStudentAttendance(code);

    if (!mounted) return;

    if (result.success) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF16A34A),
                  size: 46,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'تم تأكيد الحضور بنجاح!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                result.message,
                style: const TextStyle(fontSize: 14, color: Color(0xFF475569)),
                textAlign: TextAlign.center,
              ),
              if (result.session != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('القاعة', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 2),
                          Text(
                            result.session!.hall,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(height: 24, width: 1, color: Colors.grey.shade300),
                      Column(
                        children: [
                          const Text('المحاضر', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 2),
                          Text(
                            result.session!.doctorName,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('تم'),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFDC2626),
                  size: 42,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'تعذر تسجيل الحضور',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                result.message,
                style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('إغلاق'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // --- Teacher Actions ---

  void _createSession() {
    AppState.instance.createAttendanceSession(
      courseName: _selectedCourseName,
      courseCode: _selectedCourseCode,
      doctorName: _doctorName,
      hall: _hall,
      sessionType: _sessionType,
      durationMinutes: _durationMinutes,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.qr_code_2_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text('تم إنشاء رمز الحضور QR لمقرر $_selectedCourseName بنجاح!'),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showAddManualStudentDialog() {
    final nameCtrl = TextEditingController();
    final idCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF4F46E5)),
            SizedBox(width: 8),
            Text('إضافة طالب يدوياً', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'يمكنك تسجيل حضور طالب في حالة تعذر مسح الرمز من هاتفه.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'اسم الطالب رباعي',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: idCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الرقم الجامعي (ID)',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final name = nameCtrl.text.trim();
              final id = idCtrl.text.trim();
              if (name.isNotEmpty && id.isNotEmpty) {
                AppState.instance.addManualAttendeeToActiveSession(name, id);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تمت إضافة الطالب $name لكشف الحضور'),
                    backgroundColor: const Color(0xFF10B981),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('تسجيل الحضور'),
          ),
        ],
      ),
    );
  }

  void _openProjectorMode(AttendanceSession session) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (ctx) => _ProjectorViewDialog(session: session),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final appState = AppState.instance;
        final records = appState.attendanceRecords;
        final activeSession = appState.activeAttendanceSession;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text('نظام الحضور الذكي بالـ QR'),
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildPortalTab(
                        index: 0,
                        title: 'بوابة الطالب',
                        subtitle: 'مسح QR والغياب',
                        icon: Icons.school_rounded,
                      ),
                    ),
                    Expanded(
                      child: _buildPortalTab(
                        index: 1,
                        title: 'بوابة المحاضر',
                        subtitle: 'توليد QR وإدارة الجلسة',
                        icon: Icons.co_present_rounded,
                        badgeCount: (activeSession != null && activeSession.isActive)
                            ? activeSession.attendees.length
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: _portalModeIndex == 0
              ? _buildStudentView(records, activeSession)
              : _buildTeacherView(activeSession),
        );
      },
    );
  }

  Widget _buildPortalTab({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    int? badgeCount,
  }) {
    final isSelected = _portalModeIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _portalModeIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3730A3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3730A3).withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : const Color(0xFF4338CA),
            ),
            const SizedBox(width: 6),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF1E1B4B),
                      ),
                    ),
                    if (badgeCount != null) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF10B981) : const Color(0xFF4F46E5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9,
                    color: isSelected ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // STUDENT PORTAL VIEW
  // ==========================================

  Widget _buildStudentView(List<Attendance> records, AttendanceSession? activeSession) {
    final presentCount = records.where((r) => r.isPresent).length;
    final absentCount = records.where((r) => !r.isPresent).length;
    final totalCount = records.length;
    final percent = totalCount > 0 ? (presentCount / totalCount * 100).toInt() : 0;

    final filteredRecords = records.where((r) {
      if (_studentFilterIndex == 1) return r.isPresent;
      if (_studentFilterIndex == 2) return !r.isPresent;
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Live Active Session Banner (if teacher has started a session)
        if (activeSession != null && activeSession.isActive && !activeSession.isExpired) ...[
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF047857), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.sensors_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'جلسة نشطة الآن',
                              style: TextStyle(
                                color: Color(0xFF065F46),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'متبقي ${activeSession.remainingTime.inMinutes}:${(activeSession.remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activeSession.courseName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${activeSession.doctorName} • ${activeSession.hall}',
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF065F46),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _openQrScanner(prefillCode: activeSession.sessionCode),
                  child: const Text(
                    'تسجيل الآن',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Header Card with Student Attendance Rate & Quick Scan Button
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3730A3), Color(0xFF4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(79, 70, 229, 0.28),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'نسبة حضور الفصل الدراسي',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '$percent%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'حاضر: $presentCount',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'غائب: $absentCount',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF3730A3),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () => _openQrScanner(),
                        icon: const Icon(Icons.qr_code_scanner_rounded, size: 22),
                        label: const Text(
                          'مسح الـ QR',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white.withValues(alpha: 0.9),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        ),
                        onPressed: () => _openQrScanner(),
                        icon: const Icon(Icons.keyboard_outlined, size: 14),
                        label: const Text('إدخال كود يدوياً', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Filter Chips Row
        Row(
          children: [
            _buildStudentFilterChip(0, 'الكل ($totalCount)'),
            const SizedBox(width: 8),
            _buildStudentFilterChip(1, 'حاضر ($presentCount)'),
            const SizedBox(width: 8),
            _buildStudentFilterChip(2, 'غائب ($absentCount)'),
          ],
        ),
        const SizedBox(height: 12),

        // List of Course Attendance Records
        ...filteredRecords.map((item) => _buildCourseRecordCard(item)),
      ],
    );
  }

  Widget _buildStudentFilterChip(int index, String label) {
    final isSelected = _studentFilterIndex == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _studentFilterIndex = index),
      selectedColor: const Color(0xFF3730A3),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF475569),
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? const Color(0xFF3730A3) : const Color(0xFFCBD5E1),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildCourseRecordCard(Attendance item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.courseCode,
                  style: const TextStyle(
                    color: Color(0xFF4338CA),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item.isPresent ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.isPresent ? Icons.check_circle_rounded : Icons.cancel_rounded,
                      size: 14,
                      color: item.isPresent ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.isPresent ? 'حاضر' : 'غائب',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: item.isPresent ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.courseName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                item.lectureTime,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const Spacer(),
              if (item.scannedAt != null) ...[
                const Icon(Icons.qr_code, size: 13, color: Color(0xFF10B981)),
                const SizedBox(width: 4),
                Text(
                  'تم التسجيل عبر QR',
                  style: TextStyle(fontSize: 11, color: Colors.green.shade700),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                item.hall,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const Spacer(),
              Text(
                item.doctorName,
                style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
              ),
            ],
          ),
          if (!item.isPresent) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4F46E5),
                  side: const BorderSide(color: Color(0xFFC7D2FE)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _openQrScanner(prefillCode: item.courseCode),
                icon: const Icon(Icons.qr_code_scanner, size: 16),
                label: const Text('تسجيل الحضور لهذه المادة عبر الـ QR'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // TEACHER PORTAL VIEW (GENERATE QR)
  // ==========================================

  Widget _buildTeacherView(AttendanceSession? activeSession) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: [
        // Active Session Card (If session is running)
        if (activeSession != null && activeSession.isActive) ...[
          _buildActiveTeacherSessionCard(activeSession),
          const SizedBox(height: 20),
          _buildAttendeesListCard(activeSession),
          const SizedBox(height: 20),
        ],

        // Create New Session Form Card
        _buildCreateSessionCard(isExistingActive: activeSession != null && activeSession.isActive),
      ],
    );
  }

  Widget _buildActiveTeacherSessionCard(AttendanceSession session) {
    final remaining = session.remainingTime;
    final isExpired = session.isExpired;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFC7D2FE), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(79, 70, 229, 0.12),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Status Badge & Fullscreen Mode
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isExpired
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isExpired ? Colors.red : const Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isExpired ? 'انتهت صلاحية الجلسة' : 'جلسة الحضور نشطة الآن',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isExpired ? Colors.red.shade800 : const Color(0xFF15803D),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'عرض شاشة كاملة للمدرج / البروجيكتور',
                onPressed: () => _openProjectorMode(session),
                icon: const Icon(Icons.fullscreen_rounded, color: Color(0xFF4338CA), size: 26),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Course title and info
          Text(
            session.courseName,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${session.doctorName} • ${session.hall} • ${session.sessionType}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // THE QR CODE DISPLAY
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: session.qrPayload,
              version: QrVersions.auto,
              size: 210.0,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF1E1B4B),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF312E81),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Short Session Code for easy typing
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('كود الدخول السريع: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  session.sessionCode,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Color(0xFF3730A3),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: session.sessionCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم نسخ كود الجلسة إلى الحافظة'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Icon(Icons.copy_rounded, size: 16, color: Color(0xFF4338CA)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Countdown Timer Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('الوقت المتبقي', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 16, color: Color(0xFFD97706)),
                        const SizedBox(width: 4),
                        Text(
                          isExpired
                              ? '00:00'
                              : '${remaining.inMinutes.toString().padLeft(2, '0')}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(height: 30, width: 1, color: Colors.grey.shade300),
                Column(
                  children: [
                    const Text('عدد الحاضرين', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.people_alt_outlined, size: 16, color: Color(0xFF10B981)),
                        const SizedBox(width: 4),
                        Text(
                          '${session.attendees.length} طالب',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Controls Row: Extend time, Projector, End session
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4338CA),
                    side: const BorderSide(color: Color(0xFFC7D2FE)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    AppState.instance.extendActiveSession(5);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم تمديد جلسة الحضور بمقدار 5 دقائق إضافية'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_time_rounded, size: 18),
                  label: const Text('+5 دقائق'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    AppState.instance.endActiveAttendanceSession();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إنهاء جلسة الحضور واعتماد الكشف بنجاح'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.stop_circle_outlined, size: 18),
                  label: const Text('إنهاء الجلسة'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendeesListCard(AttendanceSession session) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.fact_check_rounded, color: Color(0xFF4F46E5), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'كشف الطلاب المسجلين (${session.attendees.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: _showAddManualStudentDialog,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('إضافة يدوية', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (session.attendees.isEmpty) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'لم يقم أي طالب بالمسح حتى الآن...\nسوف يظهر الطلاب فور مسح الـ QR',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ),
          ] else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: session.attendees.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, idx) {
                final attendee = session.attendees[idx];
                final timeStr =
                    '${attendee.timestamp.hour.toString().padLeft(2, '0')}:${attendee.timestamp.minute.toString().padLeft(2, '0')}:${attendee.timestamp.second.toString().padLeft(2, '0')}';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFFEEF2FF),
                        child: Text(
                          '${idx + 1}',
                          style: const TextStyle(
                            color: Color(0xFF4338CA),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attendee.studentName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'رقم القيد: ${attendee.studentId} • ${attendee.faculty}',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'حاضر',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            timeStr,
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCreateSessionCard({required bool isExistingActive}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_to_photos_rounded, color: Color(0xFF4F46E5), size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                isExistingActive ? 'إنشاء جلسة حضور جديدة لمقرر آخر' : 'إنشاء رمز الـ QR لجلسة الحضور',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Course Selector Dropdown
          const Text(
            'اختر المقرر الدراسي:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedCourseCode,
                items: _availableCourses.map((c) {
                  return DropdownMenuItem<String>(
                    value: c['code'],
                    child: Text('${c['name']} (${c['code']})', style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    final item = _availableCourses.firstWhere((c) => c['code'] == val);
                    setState(() {
                      _selectedCourseCode = item['code']!;
                      _selectedCourseName = item['name']!;
                      _doctorName = item['doctor']!;
                      _hall = item['hall']!;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Doctor Name and Hall
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('المحاضر / الدكتور:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: _doctorName,
                      key: Key(_doctorName),
                      onChanged: (v) => _doctorName = v,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('القاعة / المدرج:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: _hall,
                      key: Key(_hall),
                      onChanged: (v) => _hall = v,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Session Type (محاضرة / سكشن)
          const Text('نوع الجلسة:', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Row(
            children: [
              ChoiceChip(
                label: const Text('محاضرة نظري'),
                selected: _sessionType == 'محاضرة نظري',
                onSelected: (_) => setState(() => _sessionType = 'محاضرة نظري'),
                selectedColor: const Color(0xFF3730A3),
                labelStyle: TextStyle(
                  color: _sessionType == 'محاضرة نظري' ? Colors.white : Colors.black87,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('سكشن عملي'),
                selected: _sessionType == 'سكشن عملي',
                onSelected: (_) => setState(() => _sessionType = 'سكشن عملي'),
                selectedColor: const Color(0xFF3730A3),
                labelStyle: TextStyle(
                  color: _sessionType == 'سكشن عملي' ? Colors.white : Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Duration picker chips
          const Text('مدة صلاحية رمز الـ QR:', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Row(
            children: [5, 10, 15, 30].map((dur) {
              final isSel = _durationMinutes == dur;
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ChoiceChip(
                  label: Text('$dur دقائق'),
                  selected: isSel,
                  onSelected: (_) => setState(() => _durationMinutes = dur),
                  selectedColor: const Color(0xFF4F46E5),
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : Colors.black87,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Create / Generate QR Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3730A3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 3,
              ),
              onPressed: _createSession,
              icon: const Icon(Icons.qr_code_2_rounded, size: 24),
              label: const Text(
                'توليد رمز الـ QR وبدء أخذ الغياب',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// INTERACTIVE QR SCANNER BOTTOM SHEET
// ==========================================

class _QrScannerSheet extends StatefulWidget {
  final String? prefillCode;
  final Function(String code) onScanned;

  const _QrScannerSheet({
    this.prefillCode,
    required this.onScanned,
  });

  @override
  State<_QrScannerSheet> createState() => _QrScannerSheetState();
}

class _QrScannerSheetState extends State<_QrScannerSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scanAnimation;
  late TextEditingController _manualInputCtrl;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _manualInputCtrl = TextEditingController(text: widget.prefillCode ?? '');

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _manualInputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = AppState.instance.activeAttendanceSession;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'مسح رمز الحضور الذكي (QR Scanner)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 6),
          Text(
            'وجّه الكاميرا نحو شاشة المحاضر أو شاشة العرض لتسجيل حضورك',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Camera Viewport Simulation with Animated Laser
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF4F46E5), width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Viewfinder corners
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  // Center QR Icon
                  Icon(
                    Icons.qr_code_2_rounded,
                    size: 110,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),

                  // Animated Scanning Laser Bar
                  AnimatedBuilder(
                    animation: _scanAnimation,
                    builder: (context, _) {
                      return Positioned(
                        top: 25 + (_scanAnimation.value * 165),
                        child: Container(
                          width: 170,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFF38BDF8),
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF38BDF8).withValues(alpha: 0.9),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Simulated Torch Control in Scanner
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => setState(() => _torchOn = !_torchOn),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _torchOn ? Colors.amber : Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _torchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                          size: 18,
                          color: _torchOn ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Instant Test Action Button (Scans active teacher session immediately)
          if (active != null && active.isActive) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF047857),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  widget.onScanned(active.sessionCode);
                },
                icon: const Icon(Icons.bolt_rounded, size: 20),
                label: Text(
                  'مسح رمز محاضرة (${active.courseName}) فورياً',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Manual Entry Input Field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _manualInputCtrl,
                  decoration: InputDecoration(
                    hintText: 'أو اكتب كود الجلسة (مثال: SE-3015)',
                    prefixIcon: const Icon(Icons.pin_outlined),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    fillColor: const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final text = _manualInputCtrl.text.trim();
                  if (text.isNotEmpty) {
                    widget.onScanned(text);
                  }
                },
                child: const Text('تأكيد'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PROJECTOR FULLSCREEN DIALOG FOR CLASSROOMS
// ==========================================

class _ProjectorViewDialog extends StatelessWidget {
  final AttendanceSession session;

  const _ProjectorViewDialog({required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('شاشة العرض للمدرج (Projector Mode)'),
        leading: IconButton(
          icon: const Icon(Icons.close_fullscreen_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF10B981)),
                ),
                child: const Text(
                  'جلسة تسجيل الحضور نشطة',
                  style: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                session.courseName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                '${session.doctorName} • ${session.hall}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 28),

              // Massive QR Code for students in back of hall
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.4),
                      blurRadius: 36,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: session.qrPayload,
                  version: QrVersions.auto,
                  size: 280.0,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF0F172A),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Large code badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'كود الجلسة: ${session.sessionCode}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Attendee live count counter
              AnimatedBuilder(
                animation: AppState.instance,
                builder: (context, _) {
                  return Text(
                    'تم تسجيل: ${session.attendees.length} طالب حتى الآن',
                    style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 16),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
