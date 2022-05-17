import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:local_todos/hive_db.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _allTodos = [];

  final _todoController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _allTodos = HiveDB.getAllTodos();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
        title: const Text('Todos'),
      ),
      body: _allTodos.isEmpty
          ? const Center(
              child: Text(
                'No todos yet',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: ListView.builder(
                itemCount: _allTodos.length,
                itemBuilder: (BuildContext context, int index) {
                  final _todo = _allTodos[index];

                  return GestureDetector(
                    onDoubleTap: () {
                      HiveDB.deleteTodo(_todo['key']);
                      setState(() {
                        _allTodos = HiveDB.getAllTodos();
                      });
                    },
                    child: Card(
                      elevation: 6.0,
                      child: CheckboxListTile(
                        checkColor: Colors.white,
                        activeColor: Colors.indigo,
                        value: _todo['status'],
                        onChanged: (val) {
                          HiveDB.updateTodo(_todo['key'], {
                            'todo': _todo['todo'],
                            'status': val,
                            'date': DateTime.now().toString()
                          });
                          setState(() {
                            _allTodos = HiveDB.getAllTodos();
                          });
                        },
                        title: Text(
                          _todo['todo'],
                          style: TextStyle(
                              decoration: _todo['status']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(_todo['date']),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        child: Icon(Icons.add),
        onPressed: () => showAddDialogCard(),
      ),
    );
  }

  void showAddDialogCard() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add Todo',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _todoController,
                decoration: const InputDecoration(hintText: 'Add Todo'),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
                onPressed: () {
                  HiveDB.addTodo({
                    'todo': _todoController.text,
                    'status': false,
                    'date': DateTime.now().toString()
                  });
                  setState(() {
                    _allTodos = HiveDB.getAllTodos();
                  });
                  _todoController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add')),
          ],
        );
      },
    );
  }
}
