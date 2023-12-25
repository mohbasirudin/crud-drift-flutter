import 'package:drift/drift.dart';

class Task extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get value => text()();
  TextColumn get createdAt => text()();
}
