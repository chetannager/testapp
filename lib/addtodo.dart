import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  dynamic addTodo(title, message) async {
    var databasesPath = await getDatabasesPath();

    Database db = await openDatabase(
      databasesPath + 'todos.db',
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE todos (id INTEGER PRIMARY KEY, title TEXT, message TEXT)');
      },
    );

    int id = await db.rawInsert(
        'INSERT INTO todos(id, title, message) VALUES(?,?,?)',
        [DateTime.now().millisecondsSinceEpoch, title, message]);
    Navigator.pop(context, "isTodoAdded");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todo"),
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
          ),
          TextField(
            controller: messageController,
          ),
          RaisedButton(
            onPressed: () {
              addTodo(titleController.text, messageController.text);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }
}
