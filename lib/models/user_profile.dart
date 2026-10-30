class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.bio,
  });

  final String name;
  final String email;
  final String bio;

  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();
}
