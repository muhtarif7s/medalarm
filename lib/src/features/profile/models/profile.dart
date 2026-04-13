class Profile {
  final String name;
  final String email;

  Profile({required this.name, required this.email});

  Profile copyWith({String? name, String? email}) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
