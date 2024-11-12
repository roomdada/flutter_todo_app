import 'package:flutter/material.dart';
import 'package:todo_app/db/sqlite_db.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MyToApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> todos = [];

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      int randomInt = Random().nextInt(100);
      setState(() {
        todos.add({'id': randomInt, 'task': _controller.text, 'done': 0});
      });
      print(todos);
      _controller.clear();
    }
  }

  void _updateTodo(id, value) {
    setState(() {
      final index = todos.indexWhere((todo) => todo['id'] == id);
      if (index != -1) {
        todos[index]['done'] = value;
      }
    });
  }

  void _deleteTodo(id) {
    setState(() {
      todos.removeWhere((todo) => todo['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Ajouter une nouvelle tache",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _addTodo();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    onLongPress: () {
                      _deleteTodo(todo['id']);
                    },
                    title: Text(
                      todo['task'],
                      style: TextStyle(
                          decoration: todo['done'] == 1
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    trailing: Checkbox(
                        value: todo['done'] == 1,
                        onChanged: (value) {
                          _updateTodo(todo['id'], todo['done'] == 1 ? 0 : 1);
                        }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
