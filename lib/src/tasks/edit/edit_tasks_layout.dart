import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/src/dashboard/page.dart';

class EditTaksPage extends StatefulWidget {
  final Map taskData;
  const EditTaksPage({super.key, required this.taskData});

  @override
  State<EditTaksPage> createState() => _EditTaksPageState();
}

class _EditTaksPageState extends State<EditTaksPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final taskDetailController = TextEditingController();
  final noteController = TextEditingController();

  Future _putTask(String id) async {
    final response = await http.put(
      Uri.parse('http://192.168.1.114:3000/tasks/$id'),
      body: {
        'task_detail': taskDetailController.text,
        'note': noteController.text,
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task berhasil diedit')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal edit task')));
    }
  }

  @override
  void initState() {
    super.initState();
    taskDetailController.text = widget.taskData['task_detail'] ?? '';
    noteController.text = widget.taskData['note'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todolist")),
      body: Container(
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
                    controller: taskDetailController,
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _putTask(widget.taskData['id'].toString());
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
