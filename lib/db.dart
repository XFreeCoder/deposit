import 'package:deposit/constants.dart';
import 'package:deposit/models/deposit_plan.dart' as deposit_plan;
import 'package:deposit/models/tag.dart' as tag;
import 'package:deposit/models/transaction.dart' as transaction;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> _openDB() async {
  final db = await openDatabase(
    join(await getDatabasesPath(), databaseName),
    onCreate: (db, version) async {
      await db.execute(deposit_plan.createTable);
      await db.execute(transaction.createTable);
      await db.execute(tag.createTable);
    },
    version: 1,
  );

  return db;
}

final database = _openDB();
