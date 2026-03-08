class Profile {
  final int id;
  final String name;
  final int age;
  final double weight;
  final double height;

  Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      weight: map['weight'],
      height: map['height'],
    );
  }
}
