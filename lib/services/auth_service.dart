import '../models/student.dart';

class AuthService {
  Future<Student?> login(String email, String password) async {
    // محاكاة عملية تسجيل الدخول
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) {
      return Student(
        id: '20241050',
        name: 'محمد عبد العال',
        email: email,
        faculty: 'حاسبات ومعلومات',
        university: 'جامعة دمنهور',
      );
    }
    return null;
  }
}
