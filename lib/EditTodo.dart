import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class EditTodo extends StatefulWidget {
  const EditTodo({Key? key}) : super(key: key);

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
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
        title: const Text("Update Todo"),
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
