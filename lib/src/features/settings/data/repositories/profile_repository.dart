import 'package:myapp/src/features/settings/data/models/profile_model.dart';
import 'package:sqflite/sqflite.dart';

class ProfileRepository {
  final Database database;

  ProfileRepository({required this.database});

  Future<void> createProfileTable() async {
    await database.execute('''
        CREATE TABLE IF NOT EXISTS profile(
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          age INTEGER NOT NULL,
          weight REAL NOT NULL,
          height REAL NOT NULL
        )
      ''');
  }

  Future<void> saveProfile(Profile profile) async {
    await database.insert('profile', profile.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Profile?> getProfile() async {
    final maps = await database.query('profile', where: 'id = ?', whereArgs: [0]);
    if (maps.isNotEmpty) {
      return Profile.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
