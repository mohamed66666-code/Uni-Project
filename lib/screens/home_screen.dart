import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../widgets/service_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;
    final student = appState.currentStudent;
    final unreadCount = appState.unreadNotificationsCount;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 19,
                    backgroundColor: Color(0xFFEEF2FF),
                    child: Icon(Icons.person, color: Color(0xFF4338CA), size: 22),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    student?.name ?? 'محمد عبد العال',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${student?.faculty ?? "حاسبات ومعلومات"} • المستوى 3',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Wallet Balance Pill
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/payments'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFC7D2FE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_rounded, size: 14, color: Color(0xFF4338CA)),
                  const SizedBox(width: 4),
                  Text(
                    '${appState.walletBalance.toStringAsFixed(0)} ج.م',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4338CA),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Notifications Bell with Badge
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, size: 24),
                if (unreadCount > 0)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E1B4B), Color(0xFF3730A3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 42, color: Color(0xFF3730A3)),
              ),
              accountName: Text(
                student?.name ?? 'محمد عبد العال',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: Text(
                'الرقم: ${student?.id ?? "20241050"} • ${student?.email ?? ""}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_rounded, color: Color(0xFF4F46E5)),
              title: const Text('الجدول الدراسي الأسبوعي'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/schedule');
              },
            ),
            ListTile(
              leading: const Icon(Icons.grade_rounded, color: Color(0xFF10B981)),
              title: const Text('النتائج والسجل الأكاديمي'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/grades');
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_rounded, color: Color(0xFFD97706)),
              title: const Text('المكتبة الرقمية والكتب'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/library');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFFDC2626)),
              title: const Text('جدول الامتحانات ورقم الجلوس'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/exams');
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent_rounded, color: Color(0xFF7C3AED)),
              title: const Text('الشكاوى والمقترحات والطلبات'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/inquiries');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined, color: Color(0xFF0F172A)),
              title: const Text('المظهر الليلي (Dark Mode)'),
              trailing: Switch.adaptive(
                value: appState.isDarkMode,
                activeTrackColor: const Color(0xFF4F46E5),
                onChanged: (val) {
                  appState.toggleDarkMode(val);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Next Lecture / Academic Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF312E81), Color(0xFF4338CA), Color(0xFF6366F1)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(67, 56, 202, 0.28),
                    blurRadius: 18,
                    offset: Offset(0, 8),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.schedule_rounded, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'المحاضرة القادمة اليوم',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF34D399),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'GPA: ${appState.calculatedGpa.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'نظم إدارة قواعد البيانات (DBMS)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'قاعة 304 • مبنى كلية الحاسبات والمعلومات • 11:30 ص',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF312E81),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => Navigator.pushNamed(context, '/attendance'),
                          icon: const Icon(Icons.qr_code_scanner, size: 16),
                          label: const Text('تسجيل الحضور QR'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/schedule'),
                        child: const Text('الجدول الأسبوعي'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Quick Academic Shortcuts Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickPill(
                    icon: Icons.calendar_month_rounded,
                    label: 'جدولي الأسبوعي',
                    color: const Color(0xFF4F46E5),
                    onTap: () => Navigator.pushNamed(context, '/schedule'),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickPill(
                    icon: Icons.analytics_outlined,
                    label: 'النتائج والـ GPA',
                    color: const Color(0xFF059669),
                    onTap: () => Navigator.pushNamed(context, '/grades'),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickPill(
                    icon: Icons.menu_book_rounded,
                    label: 'المكتبة الرقمية',
                    color: const Color(0xFFD97706),
                    onTap: () => Navigator.pushNamed(context, '/library'),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickPill(
                    icon: Icons.assignment_outlined,
                    label: 'رقم الجلوس',
                    color: const Color(0xFFDC2626),
                    onTap: () => Navigator.pushNamed(context, '/exams'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Services Grid Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'بوابة الخدمات الأكاديمية والطلابية',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '10 خدمات متكاملة',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Full Comprehensive Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                ServiceCard(
                  title: 'حضور المحاضرات',
                  subtitle: 'سجل وغياب المواد',
                  icon: Icons.qr_code_scanner_rounded,
                  accentColor: const Color(0xFF4F46E5),
                  badgeText: 'محدث',
                  onTap: () => Navigator.pushNamed(context, '/attendance'),
                ),
                ServiceCard(
                  title: 'الجدول الدراسي',
                  subtitle: 'مواعيد وقاعات الأسبوع',
                  icon: Icons.calendar_month_rounded,
                  accentColor: const Color(0xFF2563EB),
                  onTap: () => Navigator.pushNamed(context, '/schedule'),
                ),
                ServiceCard(
                  title: 'النتائج والتقديرات',
                  subtitle: 'سجل الدرجات والـ GPA',
                  icon: Icons.grade_rounded,
                  accentColor: const Color(0xFF059669),
                  badgeText: '3.65',
                  onTap: () => Navigator.pushNamed(context, '/grades'),
                ),
                ServiceCard(
                  title: 'المكتبة والمقررات',
                  subtitle: 'كتب ومذكرات PDF',
                  icon: Icons.menu_book_rounded,
                  accentColor: const Color(0xFFD97706),
                  onTap: () => Navigator.pushNamed(context, '/library'),
                ),
                ServiceCard(
                  title: 'الامتحانات ولجنتي',
                  subtitle: 'رقم الجلوس والمقر',
                  icon: Icons.assignment_turned_in_rounded,
                  accentColor: const Color(0xFFDC2626),
                  badgeText: 'جديد',
                  onTap: () => Navigator.pushNamed(context, '/exams'),
                ),
                ServiceCard(
                  title: 'المصروفات والرسوم',
                  subtitle: 'سداد وفواتير إلكترونية',
                  icon: Icons.account_balance_wallet_rounded,
                  accentColor: const Color(0xFFE11D48),
                  badgeText: 'مستحق',
                  onTap: () => Navigator.pushNamed(context, '/payments'),
                ),
                ServiceCard(
                  title: 'مطعم الجامعة',
                  subtitle: 'وجبات اليوم والاشتراك',
                  icon: Icons.restaurant_rounded,
                  accentColor: const Color(0xFF10B981),
                  onTap: () => Navigator.pushNamed(context, '/restaurant'),
                ),
                ServiceCard(
                  title: 'الرحلات الطلابية',
                  subtitle: 'أنشطة ومعسكرات',
                  icon: Icons.explore_rounded,
                  accentColor: const Color(0xFFEA580C),
                  onTap: () => Navigator.pushNamed(context, '/trips'),
                ),
                ServiceCard(
                  title: 'الشكاوى والمقترحات',
                  subtitle: 'تذاكر ودعم الطلاب',
                  icon: Icons.support_agent_rounded,
                  accentColor: const Color(0xFF7C3AED),
                  onTap: () => Navigator.pushNamed(context, '/inquiries'),
                ),
                ServiceCard(
                  title: 'أخبار الجامعة',
                  subtitle: 'الجداول والإعلانات',
                  icon: Icons.campaign_rounded,
                  accentColor: const Color(0xFF0284C7),
                  badgeText: '3 جديدة',
                  onTap: () => Navigator.pushNamed(context, '/news'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        selectedItemColor: const Color(0xFF3730A3),
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: (index) {
          setState(() => _currentNavIndex = index);
          if (index == 1) Navigator.pushNamed(context, '/schedule');
          if (index == 2) Navigator.pushNamed(context, '/grades');
          if (index == 3) Navigator.pushNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'الجدول',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade_rounded),
            label: 'النتائج',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPill({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
