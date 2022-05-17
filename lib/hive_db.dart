import 'dart:ffi';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class HiveDB {
  static final _todoList = Hive.box('todo_list');

  // {
  //   "name": "naveen",
  //   "age": 1,
  //   "isMajor": true
  // }

  // [
  //   {},
  //   {}
  // ]

  // Read data from Hive
  static List<Map<String, dynamic>> getAllTodos() {
    var todoList = _todoList.keys.map((key) {
      var value = _todoList.get(key);
      return {
        'key': key,
        'todo': value['todo'],
        'status': value['status'],
        'date': value['date']
      };
    }).toList();
    return todoList;
  }

  // Add Todo
  static Future<void> addTodo(Map<String, dynamic> newTodo) async {
    await _todoList.add(newTodo);
  }

  // Update Todo
  static Future<void> updateTodo(
      int todoKey, Map<String, dynamic> updatedTodo) async {
    await _todoList.put(todoKey, updatedTodo);
  }

  // Delete Todo
  static Future<void> deleteTodo(int todoKey) async {
    await _todoList.delete(todoKey);
  }
}
