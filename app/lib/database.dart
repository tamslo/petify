import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Import table and model definitions
// When adding a new table: add table creation in initializeDatabase() and the
//   retrieve method; if applicable, add the retrieve method to retrieveData()
import 'package:petify/models/pet.dart';
import 'package:petify/models/petification.dart';

class DatabaseProvider {
  static final DatabaseProvider _databaseProvider = DatabaseProvider._();

  DatabaseProvider._();

  late Database database;

  factory DatabaseProvider() {
    return _databaseProvider;
  }

  Future<void> initializeDatabase() async {
    const databaseName = 'petify_database.db';
    final databasePath = join(await getDatabasesPath(), databaseName);
    database = await openDatabase(
      databasePath,
      onCreate: (database, version) {
        database.execute(petCreateStatement);
        database.execute(petificationCreateStatement);
      },
      version: 1,
    );
  }

  // Table-specific methods

  Future<Map> retrieveData() async {
    final Map data = {
      petTableName: await retrievePets(),
      petificationTableName: await retrievePetifications(),
    };
    return data;
  }

  Future<List<dynamic>> retrievePets() async {
    final List<Map<String, Object?>> queryResults =
        await database.query(petTableName);
    return queryResults.map((queryResult) => Pet.fromMap(queryResult)).toList();
  }

  Future<List<dynamic>> retrievePetifications() async {
    final List<Map<String, Object?>> queryResults =
        await database.query(petificationTableName);
    return queryResults
        .map((queryResult) => Petification.fromMap(queryResult))
        .toList();
  }

  // Generic methods (create, update, delete)

  Future<int> insertInstance(String table, dynamic instance) async {
    int result = await database.insert(table, instance.toMap());
    return result;
  }

  Future<int> updateInstance(String table, dynamic instance) async {
    int result = await database.update(
      table,
      instance.toMap(),
      where: "id = ?",
      whereArgs: [instance.id],
    );
    return result;
  }

  Future<void> deleteInstance(String table, int id) async {
    await database.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
