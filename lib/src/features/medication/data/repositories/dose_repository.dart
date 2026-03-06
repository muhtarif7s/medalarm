import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:myapp/src/features/medication/data/models/dose.dart';

class DoseRepository {
  static final DoseRepository instance = DoseRepository._init();

  static Database? _database;

  DoseRepository._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('medication.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE IF NOT EXISTS medications (
        id $idType,
        name $textType,
        dosage $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS doses (
        id $idType,
        medicationId $integerType,
        time $textType,
        status $integerType
      )
    ''');
  }

  Future<Dose> insert(Dose dose) async {
    final db = await instance.database;
    final id = await db.insert('doses', dose.toMap());
    return Dose(id: id, medicationId: dose.medicationId, time: dose.time, status: dose.status);
  }

  Future<List<Dose>> getAll() async {
    final db = await instance.database;
    final result = await db.query('doses');
    return result.map((json) => Dose.fromMap(json)).toList();
  }

  Future<int> update(Dose dose) async {
    final db = await instance.database;
    return db.update(
      'doses',
      dose.toMap(),
      where: 'id = ?',
      whereArgs: [dose.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'doses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
