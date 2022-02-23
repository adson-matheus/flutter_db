import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Human {
  final int id;
  final String name;
  final int age;

  Human({required this.id, required this.name, required this.age});

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
  }
}
