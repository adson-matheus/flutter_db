import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//database crud flutter
//https://docs.flutter.dev/cookbook/persistence/sqlite#6-retrieve-the-list-of-dogs

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
          'CREATE TABLE humans(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)');
    },
    version: 1,
  );

  Future<void> insertHuman(Human human) async {
    final db = await database;
    await db.insert('humans', human.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Human>> getHuman() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'humans',
    );

    return List.generate(maps.length, (i) {
      return Human(
          id: maps[i]['id'], name: maps[i]['name'], age: maps[i]['age']);
    });
  }

  Future<void> updateHuman(Human human) async {
    final db = await database;

    db.update('humans', human.toMap(), where: 'id = ?', whereArgs: [human.id]);
  }

  Future<void> deleteHuman(Human human) async {
    final db = await database;

    db.delete('humans', where: 'id = ?', whereArgs: [human.id]);
  }

  //Human object
  var adson = Human(id: 0, name: 'Adson', age: 21);

  //create
  await insertHuman(adson);

  //read
  print(await getHuman());

  //update
  adson = Human(id: adson.id, name: adson.name, age: adson.age + 1);
  await updateHuman(adson);

  //read
  print(await getHuman());

  //delete
  await deleteHuman(adson);

  //read
  print(await getHuman());
}
