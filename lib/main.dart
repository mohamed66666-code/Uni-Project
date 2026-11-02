import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/news_screen.dart';
import 'screens/restaurant_screen.dart';
import 'screens/trips_screen.dart';
import 'screens/payments_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/grades_screen.dart';
import 'screens/library_screen.dart';
import 'screens/exams_screen.dart';
import 'screens/inquiries_screen.dart';
import 'screens/notifications_screen.dart';

void main() {
  runApp(const UniversityApp());
}

class UniversityApp extends StatelessWidget {
  const UniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, child) {
        final isDark = AppState.instance.isDarkMode;

        const primaryColor = Color(0xFF3730A3); // Indigo 800
        const accentColor = Color(0xFF4F46E5); // Indigo 600
        final scaffoldBg =
            isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
        final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

        return MaterialApp(
          title: 'بوابة الطالب الجامعية',
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar', 'EG'),
          supportedLocales: const [
            Locale('ar', 'EG'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            brightness: isDark ? Brightness.dark : Brightness.light,
            scaffoldBackgroundColor: scaffoldBg,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              primary: primaryColor,
              secondary: accentColor,
              surface: cardBg,
              brightness: isDark ? Brightness.dark : Brightness.light,
            ),
            appBarTheme: AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              backgroundColor: cardBg,
              foregroundColor: isDark ? Colors.white : const Color(0xFF1E293B),
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
              iconTheme: IconThemeData(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              color: cardBg,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor:
                  isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: accentColor, width: 1.5),
              ),
              prefixIconColor: const Color(0xFF64748B),
              labelStyle:
                  const TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const LoginScreen(),
            '/home': (context) => const HomeScreen(),
            '/attendance': (context) => const AttendanceScreen(),
            '/news': (context) => const NewsScreen(),
            '/restaurant': (context) => const RestaurantScreen(),
            '/trips': (context) => const TripsScreen(),
            '/payments': (context) => const PaymentsScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/schedule': (context) => const ScheduleScreen(),
            '/grades': (context) => const GradesScreen(),
            '/library': (context) => const LibraryScreen(),
            '/exams': (context) => const ExamsScreen(),
            '/inquiries': (context) => const InquiriesScreen(),
            '/notifications': (context) => const NotificationsScreen(),
          },
        );
      },
    );
  }
}
