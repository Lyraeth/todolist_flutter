import 'package:flutter/material.dart';

class DetailTasks extends StatefulWidget {
  final Map taskData;
  const DetailTasks({super.key, required this.taskData});

  @override
  State<DetailTasks> createState() => _DetailTasksState();
}

class _DetailTasksState extends State<DetailTasks> {
  final formKey = GlobalKey<FormState>();

  final id = TextEditingController();
  final taskdetail = TextEditingController();
  final note = TextEditingController();

  @override
  Widget build(BuildContext context) {
    id.text = widget.taskData['id'];
    taskdetail.text = widget.taskData['task_detail'];
    note.text = widget.taskData['note'];
    return Scaffold(
      appBar: AppBar(title: Text("Detail Products")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Task Detail :'),
                  subtitle: Text(
                    widget.taskData['task_detail'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                ListTile(
                  title: Text('Note :'),
                  subtitle: Text(
                    widget.taskData['note'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
