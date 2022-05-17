import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:local_todos/homepage.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();
  // To create box in Hive, Box is similar to table in SQL DBs
  await Hive.openBox('todo_list');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
