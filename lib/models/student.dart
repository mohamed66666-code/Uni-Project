class Student {
  final String id;
  final String name;
  final String email;
  final String faculty;
  final String university;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.faculty,
    required this.university,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      faculty: json['faculty'],
      university: json['university'],
    );
  }
}
