import 'package:flutter/material.dart';
import 'package:todolist/src/dashboard/list_data.dart';
import 'package:todolist/src/tasks/create/create_tasks_layout.dart';

class ListLayout extends StatefulWidget {
  const ListLayout({super.key});

  @override
  State<ListLayout> createState() => ListLayoutState();
}

class ListLayoutState extends State<ListLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TasksData(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTasks()),
          );
        },
      ),
    );
  }
}
