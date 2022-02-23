import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Human {
  final int id;
  final String name;
  final int age;

  Human({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'Human{id: $id, name: $name, age: $age}';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'human.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE Human (id INTEGER PRIMARY KEY, name TEXT NOT NULL, age TEXT NOT NULL)');
    },
    version: 1,
  );

  Future<void> insertHuman(Human human) async {
    final db = await database;
    await db.insert('Human', human.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  var adson = Human(id: 0, name: 'Adson', age: 21);

  await insertHuman(adson);
}
