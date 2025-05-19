import 'package:flutter/material.dart';
import 'package:todolist/service/tasks/tasks_service.dart';
import 'package:todolist/src/dashboard/page.dart';

class CreateTasksInput extends StatefulWidget {
  const CreateTasksInput({super.key});

  @override
  State<CreateTasksInput> createState() => _CreateTasksInputState();
}

class _CreateTasksInputState extends State<CreateTasksInput> {
  final taskdetailController = TextEditingController();
  final noteController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    taskdetailController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<bool> handleTasksPost() async {
    final taskDetail = taskdetailController.text;
    final note = noteController.text;

    final success = await TasksService.storeTasks(taskDetail, note);
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task berhasil dibuat')));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
        (route) => false,
      );
      return true;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Buat task gagal')));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                TextFormField(
                  controller: taskdetailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'task cannot be null';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Task detail",
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: noteController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'note cannot be null';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "note task",
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: handleTasksPost,
                  label: Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
