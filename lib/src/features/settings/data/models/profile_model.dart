class Profile {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? birthDate;

  Profile({
    required this.id,
    this.firstName,
    this.lastName,
    this.birthDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      birthDate: map['birthDate'],
    );
  }
}
