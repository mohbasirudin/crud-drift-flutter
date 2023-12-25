import 'dart:io';

import 'package:crud_drift/database/table/task.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

part 'init.g.dart';

LazyDatabase _init() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(join(dir.path, "db.sqlite"));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Task])
class AppDb extends _$AppDb {
  AppDb() : super(_init());

  @override
  int get schemaVersion => 1;

  Future<List<TaskData>> getTasks() async {
    return await select(task).get();
  }

  Future<TaskData> getTaskById(int id) async {
    return await (select(task)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<bool> updateTask(TaskCompanion value) async {
    return await update(task).replace(value);
  }

  Future<int> insertTask(TaskCompanion value) async {
    return await into(task).insert(value);
  }

  Future<int> deleteTask(int id) async {
    return await (delete(task)..where((tbl) => tbl.id.equals(id))).go();
  }
}
