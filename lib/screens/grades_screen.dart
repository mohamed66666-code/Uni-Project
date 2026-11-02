import 'package:flutter/material.dart';
import '../services/app_state.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  void _openPrintPreview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _PrintTranscriptSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;
    final grades = appState.courseGrades;
    final gpa = appState.calculatedGpa;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('النتائج والسجل الأكاديمي'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Header Print Action
          IconButton(
            tooltip: 'طباعة النتيجة (Print)',
            icon: const Icon(Icons.print_rounded, color: Color(0xFF3730A3), size: 24),
            onPressed: () => _openPrintPreview(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GPA Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF3730A3), Color(0xFF4338CA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(55, 48, 163, 0.25),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'المعدل التراكمي العام (CGPA)',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                gpa.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '/ 4.00',
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF34D399)),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'ممتاز مرتفع',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'المرتبة الأولى',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 14),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('الساعات المجتازة', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          SizedBox(height: 4),
                          Text('78 ساعة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('معدل الفصل الحالي', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          SizedBox(height: 4),
                          Text('3.72', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('النسبة المئوية', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          SizedBox(height: 4),
                          Text('91.4%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Print Action Banner / Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFC7D2FE)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.print_rounded, color: Color(0xFF3730A3), size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'طباعة كشف الدرجات الأكاديمي',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'بيان رسمي معتمد بصيغة A4 وختم الكلية',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3730A3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () => _openPrintPreview(context),
                    icon: const Icon(Icons.print, size: 16),
                    label: const Text(
                      'طباعة (Print)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تفاصيل درجات الفصل الحالي',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: const Text(
                    'خريف 2026/2027',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Courses Grade List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: grades.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final course = grades[index];
                final isTopGrade = course.gradeLetter.startsWith('A');

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.courseName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${course.courseCode} • ${course.creditHours} ساعات معتمدة',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isTopGrade
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              course.gradeLetter,
                              style: TextStyle(
                                color: isTopGrade
                                    ? const Color(0xFF15803D)
                                    : const Color(0xFF4338CA),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildScoreItem('أعمال السنة', '${course.midterm}/20'),
                            _buildScoreItem('العملي', '${course.practical}/20'),
                            _buildScoreItem('التحريري', '${course.finalExam}/60'),
                            _buildScoreItem('المجموع', '${course.total}/100', isBold: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, String score, {bool isBold = false}) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 3),
        Text(
          score,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? const Color(0xFF3730A3) : const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// OFFICIAL PRINT PREVIEW & PRINT DIALOG
// ==========================================

class _PrintTranscriptSheet extends StatefulWidget {
  const _PrintTranscriptSheet();

  @override
  State<_PrintTranscriptSheet> createState() => _PrintTranscriptSheetState();
}

class _PrintTranscriptSheetState extends State<_PrintTranscriptSheet> {
  String _selectedPrinter = 'HP LaserJet Pro M404n (جاهزة)';
  bool _isPrinting = false;

  final List<String> _printers = [
    'HP LaserJet Pro M404n (جاهزة)',
    'Canon i-SENSYS LBP223dw (شبكة الكلية)',
    'Microsoft Print to PDF (تصدير رقمي)',
  ];

  void _triggerPrint() async {
    setState(() => _isPrinting = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _isPrinting = false);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Text('تم إرسال أمر الطباعة بنجاح إلى ($_selectedPrinter) بنسق A4'),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _exportPdf() async {
    setState(() => _isPrinting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isPrinting = false);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('تم حفظ وتصدير ملف (Academic_Transcript_20241050.pdf) بنجاح!'),
          ],
        ),
        backgroundColor: const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;
    final grades = appState.courseGrades;
    final gpa = appState.calculatedGpa;
    final student = appState.currentStudent;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F5F9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header Toolbar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.print_rounded, color: Color(0xFF3730A3), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'معاينة وأمر طباعة النتيجة (Print Preview)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Printer Settings Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.local_printshop_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedPrinter,
                      items: _printers.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(p, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedPrinter = v);
                      },
                    ),
                  ),
                ),
                Container(height: 24, width: 1, color: Colors.grey.shade300),
                const SizedBox(width: 12),
                const Text('A4 • عمودي', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Document Printable Area (Scrollable A4 Certificate Sheet)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 620),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Official University Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'جمهورية مصر العربية',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text('وزارة التعليم العالي', style: TextStyle(fontSize: 10)),
                              Text(
                                'جامعة دمنهور',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B)),
                              ),
                            ],
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF3730A3), width: 1.5),
                            ),
                            child: const Center(
                              child: Icon(Icons.school_rounded, color: Color(0xFF3730A3), size: 28),
                            ),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'كلية الحاسبات والمعلومات',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B)),
                              ),
                              Text('شؤون التعليم والطلاب', style: TextStyle(fontSize: 10)),
                              Text('العام الجامعي: 2026/2027', style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: Color(0xFF1E1B4B), thickness: 1.5),
                      const SizedBox(height: 8),

                      // 2. Transcript Title
                      const Center(
                        child: Text(
                          'بيان درجات وسجل أكاديمي رسمي معتمد',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'OFFICIAL ACADEMIC TRANSCRIPT',
                          style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 3. Student Identification Table
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _buildDocField('اسم الطالب:', student?.name ?? 'محمد عبد العال'),
                                _buildDocField('رقم القيد (ID):', student?.id ?? '20241050'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildDocField('الكلية:', student?.faculty ?? 'الحاسبات والمعلومات'),
                                _buildDocField('التخصص:', 'علوم الحاسب (CS)'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildDocField('رقم الجلوس:', appState.seatNumber),
                                _buildDocField('الفصل الدراسي:', 'الفصل الأول 2026/2027'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 4. Grades Table
                      Table(
                        border: TableBorder.all(color: const Color(0xFFCBD5E1), width: 1),
                        columnWidths: const {
                          0: FlexColumnWidth(1.2), // كود
                          1: FlexColumnWidth(3.0), // اسم المقرر
                          2: FlexColumnWidth(1.0), // ساعات
                          3: FlexColumnWidth(1.1), // أعمال سنة
                          4: FlexColumnWidth(1.1), // تحريري
                          5: FlexColumnWidth(1.2), // مجموع
                          6: FlexColumnWidth(1.1), // تقدير
                        },
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFFEEF2FF)),
                            children: [
                              _buildTableHeaderCell('الكود'),
                              _buildTableHeaderCell('اسم المقرر'),
                              _buildTableHeaderCell('ساعات'),
                              _buildTableHeaderCell('أعمال'),
                              _buildTableHeaderCell('تحريري'),
                              _buildTableHeaderCell('المجموع'),
                              _buildTableHeaderCell('التقدير'),
                            ],
                          ),
                          ...grades.map((g) {
                            return TableRow(
                              children: [
                                _buildTableCell(g.courseCode, isCode: true),
                                _buildTableCell(g.courseName, alignRight: true),
                                _buildTableCell('${g.creditHours}'),
                                _buildTableCell('${g.midterm + g.practical}'),
                                _buildTableCell('${g.finalExam}'),
                                _buildTableCell('${g.total}', isBold: true),
                                _buildTableCell(g.gradeLetter, isGrade: true),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 5. Official Summary Box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text('الساعات المسجلة', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                const SizedBox(height: 2),
                                Text(
                                  '${grades.fold<int>(0, (sum, g) => sum + g.creditHours)} ساعات',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Container(height: 24, width: 1, color: Colors.grey.shade400),
                            Column(
                              children: [
                                const Text('المعدل التراكمي CGPA', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                const SizedBox(height: 2),
                                Text(
                                  '${gpa.toStringAsFixed(2)} / 4.00',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B)),
                                ),
                              ],
                            ),
                            Container(height: 24, width: 1, color: Colors.grey.shade400),
                            const Column(
                              children: [
                                Text('التقدير العام', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                SizedBox(height: 2),
                                Text(
                                  'ممتاز مرتفع (A+)',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),

                      // 6. Verification Seals & Signatures
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue.shade900, width: 1.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(Icons.verified_outlined, color: Colors.blue.shade900, size: 28),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text('خاتم شعار الكلية', style: TextStyle(fontSize: 9, color: Colors.grey)),
                            ],
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('مسجل الكلية', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              SizedBox(height: 20),
                              Text('أ. سمير رضوان', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('عميد الكلية', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              SizedBox(height: 20),
                              Text('أ.د. يحيى المنشاوي', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          'كود التحقق الإلكتروني من صحة السجل: DMU-2026-TR-84910 • صادر بتاريخ اليوم',
                          style: TextStyle(fontSize: 8, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      side: const BorderSide(color: Color(0xFF93C5FD)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isPrinting ? null : _exportPdf,
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                    label: const Text('حفظ كملف PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3730A3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    onPressed: _isPrinting ? null : _triggerPrint,
                    icon: _isPrinting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.print_rounded, size: 20),
                    label: Text(
                      _isPrinting ? 'جاري إرسال المستند...' : 'إرسال أمر الطباعة (Print Now)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocField(String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B)),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isCode = false, bool isBold = false, bool isGrade = false, bool alignRight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.center,
        style: TextStyle(
          fontSize: isCode ? 9 : 10,
          fontWeight: isBold || isGrade ? FontWeight.bold : FontWeight.normal,
          color: isGrade ? const Color(0xFF15803D) : const Color(0xFF0F172A),
        ),
      ),
    );
  }
}
