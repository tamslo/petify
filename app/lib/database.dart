import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Import table and model definitions
// When adding a new table: add table in _initializeTables
import 'package:petify/database/table_definition.dart';
import 'package:petify/database/table_names.dart';
import 'package:petify/database/models/pet.dart';
import 'package:petify/database/models/petification.dart';

class DatabaseProvider {
  static final DatabaseProvider _databaseProvider = DatabaseProvider._();

  late final Map<String, TableDefinition> tables;

  DatabaseProvider._();

  late Database database;

  factory DatabaseProvider() {
    return _databaseProvider;
  }

  void _initializeTables() {
    final petTable = TableDefinition(
        name: petTableName,
        fields: {
          'id': 'INTEGER PRIMARY KEY',
          'name': 'TEXT',
          'unixBirthdate': 'INTEGER'
        },
        model: Pet);
    final petificationTable = TableDefinition(
        name: petificationTableName,
        fields: {
          'id': 'INTEGER PRIMARY KEY',
          'petId': 'INTEGER',
          'description': 'TEXT',
          'unixTime': 'INTEGER'
        },
        parentTables: [petTable.name],
        model: Petification);
    tables = {
      petTable.name: petTable,
      petificationTable.name: petificationTable
    };
  }

  Future<void> initializeDatabase() async {
    const databaseName = 'petify_database.db';
    final databasePath = join(await getDatabasesPath(), databaseName);
    _initializeTables();
    database = await openDatabase(
      databasePath,
      onCreate: (database, version) {
        for (TableDefinition table in tables.values) {
          database.execute(table.getCreateStatement());
        }
      },
      version: 2,
    );
  }

  Future<Map> retrieveData({String table = ''}) async {
    Map<String, List<dynamic>> data = {};
    for (String tableName in tables.keys) {
      data[tableName] = await retrieveTable(tableName);
    }
    return data;
  }

  Future<List<dynamic>> retrieveTable(String tableName) async {
    final TableDefinition table = tables[tableName]!;
    final List<Map<String, Object?>> queryResults =
        await database.query(table.name);
    return queryResults
        .map((queryResult) => table.model.fromMap(queryResult))
        .toList();
  }

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
