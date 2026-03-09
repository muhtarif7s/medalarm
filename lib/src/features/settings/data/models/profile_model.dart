class Profile {
  final int id;
  final String name;
  final int age;
  final double weight;
  final double height;

  Profile({
    this.id = 0,
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
      id: map['id'] ?? 0,
      name: map['name'],
      age: map['age'],
      weight: map['weight'],
      height: map['height'],
    );
  }

  Profile copyWith({
    int? id,
    String? name,
    int? age,
    double? weight,
    double? height,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }
}
