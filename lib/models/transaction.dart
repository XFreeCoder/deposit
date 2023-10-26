import 'package:deposit/models/deposit_plan.dart' as deposit_plan;
import 'package:sqflite/sqflite.dart';

enum TransactionType { income, expense }

const String tableTransaction = 'transactions';
const String columnId = '_id';
const String columnDepositPlanId = 'deposit_plan_id';
const String columnName = 'name';
const String columnAmount = 'amount';
const String columnTransactionType = 'transaction_type';
const String columnDate = 'date';
const String columnTags = 'tags';

const String createTable = '''
            CREATE TABLE $tableTransaction(
              $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
              $columnDepositPlanId INTEGER,
              $columnName TEXT NOT NULL,
              $columnAmount REAL NOT NULL,
              $columnTransactionType TEXT NOT NULL,
              $columnDate TEXT NOT NULL,
              $columnTags TEXT NOT NULL,
              FOREIGN KEY($columnDepositPlanId) REFERENCES ${deposit_plan.tableDepositPlan}(${deposit_plan.columnId})
            )
          ''';

class Transaction {
  final int? id;
  final int depositPlanId;
  final String name;
  final num amount;
  final TransactionType type;
  final DateTime date;
  final String tags;

  const Transaction({
    this.id,
    required this.depositPlanId,
    required this.name,
    required this.amount,
    required this.type,
    required this.date,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnDepositPlanId: depositPlanId,
      columnName: name,
      columnAmount: amount,
      columnTransactionType: type.name,
      columnDate: date.toIso8601String(),
      columnTags: tags,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Transaction.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        depositPlanId = map[columnDepositPlanId],
        name = map[columnName],
        amount = map[columnAmount],
        type = map[columnTransactionType] == TransactionType.income.name
            ? TransactionType.income
            : TransactionType.expense,
        date = map[columnDate],
        tags = map[columnTags];
}

class TransactionProvider {
  final Database _db;

  TransactionProvider(this._db);

  Future<void> insert(Transaction transaction) async {
    await _db.insert(
      tableTransaction,
      transaction.toMap(),
    );
  }

  Future<Transaction?> get(int id) async {
    List<Map<String, dynamic>> maps = await _db
        .query(tableTransaction, where: '$columnId = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Transaction.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Transaction>> getAll() async {
    final List<Map<String, dynamic>> maps = await _db.query(tableTransaction);
    return maps.map((map) => Transaction.fromMap(map)).toList();
  }

  Future<int> delete(int id) async {
    return await _db
        .delete(tableTransaction, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Transaction transaction) async {
    return await _db.update(tableTransaction, transaction.toMap(),
        where: '$columnId = ?', whereArgs: [transaction.id]);
  }
}
