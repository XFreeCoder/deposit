import 'dart:ui';
import 'package:sqflite/sqflite.dart';

const String tableTag = 'tags';
const String columnId = '_id';
const String columnName = 'name';
const String columnColor = 'color';

const String createTable = '''
            CREATE TABLE $tableTag(
              $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
              $columnName TEXT NOT NULL,
              $columnColor INTEGER NOT NULL
            )
          ''';

class Tag {
  final int? id;
  final String name;
  final Color color;

  const Tag({
    this.id,
    required this.name,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnColor: color.value,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Tag.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        name = map[columnName],
        color = Color(map[columnColor]);
}

class TagProvider {
  final Database _db;

  TagProvider(this._db);

  Future<void> insert(Tag tag) async {
    await _db.insert(
      tableTag,
      tag.toMap(),
    );
  }

  Future<Tag?> get(int id) async {
    List<Map<String, dynamic>> maps =
        await _db.query(tableTag, where: '$columnId = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Tag.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Tag>> getAll() async {
    final List<Map<String, dynamic>> maps = await _db.query(tableTag);
    return maps.map((map) => Tag.fromMap(map)).toList();
  }

  Future<int> delete(int id) async {
    return await _db.delete(tableTag, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Tag tag) async {
    return await _db.update(tableTag, tag.toMap(),
        where: '$columnId = ?', whereArgs: [tag.id]);
  }
}
