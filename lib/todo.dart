import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testapp/addtodo.dart';

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  List todos = [];
  bool isLoading = true;

  dynamic fetchAllTodos() async {
    setState(() {
      todos = [];
      isLoading = true;
    });
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

    List<Map> list = await db.rawQuery('SELECT * FROM todos');
    print(list);
    setState(() {
      todos = list;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo Task"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddTodo()))
                  .then((value) {
                fetchAllTodos();
              });
            },
            icon: const Icon(Icons.add_sharp),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : todos.isEmpty
              ? const Center(
                  child: Text("No Todos Found!"),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(index.toString()),
                      child: ListTile(
                        title: Text(todos[index]["title"]),
                        subtitle: Text(todos[index]["message"]),
                        onTap: () {},
                      ),
                      onDismissed: (Di){

                      },
                    );
                  },
                  itemCount: todos.length,
                ),
    );
  }
}
