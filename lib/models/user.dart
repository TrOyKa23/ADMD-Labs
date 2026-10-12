class User {
  final String name;
  final int? age;
  final String? email;

  const User({required this.name, this.age, this.email});

  String getDisplayAge() {
    return age?.toString() ?? 'Age not specified';
  }
}
