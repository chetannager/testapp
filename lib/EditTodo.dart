import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class EditTodo extends StatefulWidget {
  int id;
  String title;
  String message;

  EditTodo(this.id, this.title, this.message);

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  final titleController = TextEditingController();
  final messageController = TextEditingController();

  dynamic updateTodo(id, title, message) async {
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

    int count = await db.rawUpdate(
        'UPDATE todos SET title = ?, message = ? WHERE id = ?',
        [title, message, id]);

    Navigator.pop(context, "isTodoAdded");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.title;
    messageController.text = widget.message;
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
            decoration: InputDecoration(
                label: Text("Title")
            ),
          ),
          TextField(
            controller: messageController,
            decoration: InputDecoration(
                label: Text("Message")
            ),
          ),
          RaisedButton(
            onPressed: () {
              updateTodo(
                  widget.id, titleController.text, messageController.text);
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }
}
