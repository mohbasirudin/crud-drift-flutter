import 'dart:math';

import 'package:crud_drift/database/init.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

final _mKey = GlobalKey<ScaffoldMessengerState>();

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _mKey,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AppDb _appDb = AppDb();

  List<TaskData> tasks = [];
  TaskData? _task;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    read();
  }

  void create() async {
    try {
      final data = TaskCompanion(
        value: drift.Value("Task ${Random().nextInt(100)}"),
        createdAt: drift.Value(DateTime.now().toString()),
      );
      var result = await _appDb.insertTask(data);
      print("insert task: $result");
      if (result > 0) read();
    } catch (e) {
      print("== [failed insert] > $e ==");
    }
  }

  void update(int id) async {
    try {
      final data = TaskCompanion(
        id: drift.Value(id),
        value: drift.Value("Task ${Random().nextInt(100)}"),
        createdAt: drift.Value(DateTime.now().toString()),
      );
      var result = await _appDb.updateTask(data);
      print("update task: $result");

      if (result) read();
    } catch (e) {
      print("== [failed update] > $e ==");
    }
  }

  void delete(int id) async {
    try {
      var result = await _appDb.deleteTask(id);

      if (result > 0) read();
    } catch (e) {
      print("== [failed delete] > $e ==");
    }
  }

  void read() async {
    try {
      tasks = await _appDb.getTasks();

      setState(() {});
    } catch (e) {
      print("== [failed read] > $e ==");
      tasks = [];
    }
  }

  void readById(int id) async {
    try {
      _task = await _appDb.getTaskById(id);
      setState(() {});
    } catch (e) {
      print("== [failed read by id] > $e ==");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "CRUD Drift",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Result: Get by Id"),
                const Divider(),
                Text("ID: ${_task != null ? _task!.id : "-"}"),
                Text("Value: ${_task != null ? _task!.value : "-"}"),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: Text("[${task.id}] => ${task.value}"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _btnText(
                            "Get by ID",
                            color: Colors.green,
                            onTap: () {
                              readById(task.id);
                            },
                          ),
                          const SizedBox(width: 12),
                          _btnText(
                            "Update",
                            color: Colors.orange,
                            onTap: () {
                              update(task.id);
                            },
                          ),
                          const SizedBox(width: 12),
                          _btnText(
                            "Delete",
                            color: Colors.red,
                            onTap: () {
                              delete(task.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: tasks.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          create();
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _btnText(
    String name, {
    required Color color,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        name,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }
}
