import 'package:sqflite/sqflite.dart';

const String tableDepositPlan = 'deposit_plans';
const String columnId = '_id';
const String columnTarget = 'target';
const String columnName = 'name';
const String columnStartDate = 'start_date';
const String columnEndDate = 'end_date';

const String createTable = '''
            CREATE TABLE $tableDepositPlan(
              $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
              $columnTarget REAL NOT NULL,
              $columnName TEXT NOT NULL,
              $columnStartDate TEXT NOT NULL,
              $columnEndDate TEXT NOT NULL
            )
          ''';

class DepositPlan {
  final int? id;
  final num target;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  const DepositPlan({
    this.id,
    required this.target,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTarget: target,
      columnName: name,
      columnStartDate: startDate.toIso8601String(),
      columnEndDate: endDate.toIso8601String(),
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  DepositPlan.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        target = map[columnTarget],
        name = map[columnName],
        startDate = DateTime.parse(map[columnStartDate]),
        endDate = DateTime.parse(map[columnEndDate]);
}

class DepositPlanProvider {
  final Database _db;

  DepositPlanProvider(this._db);

  Future<void> insert(DepositPlan depositPlan) async {
    await _db.insert(
      tableDepositPlan,
      depositPlan.toMap(),
    );
  }

  Future<DepositPlan?> get(int id) async {
    List<Map<String, dynamic>> maps = await _db
        .query(tableDepositPlan, where: '$columnId = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return DepositPlan.fromMap(maps.first);
    }
    return null;
  }

  Future<List<DepositPlan>> getAll() async {
    final List<Map<String, dynamic>> maps = await _db.query(tableDepositPlan);
    return maps.map((map) => DepositPlan.fromMap(map)).toList();
  }

  Future<int> delete(int id) async {
    return await _db
        .delete(tableDepositPlan, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(DepositPlan depositPlan) async {
    return await _db.update(tableDepositPlan, depositPlan.toMap(),
        where: '$columnId = ?', whereArgs: [depositPlan.id]);
  }
}
