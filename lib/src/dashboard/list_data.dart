import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/service/dashboard/dashboard_service.dart';
import 'package:todolist/src/tasks/detail/page.dart';
import 'package:todolist/src/tasks/edit/edit_tasks_layout.dart';

class TasksData extends StatefulWidget {
  const TasksData({super.key});

  @override
  State<TasksData> createState() => _TasksDataState();
}

class _TasksDataState extends State<TasksData> {
  List _dataToDo = [];
  bool _loading = true;

  Future _getData() async {
    final data = await DashboardService.getToDo();
    setState(() {
      _dataToDo = data;
      _loading = false;
    });
  }

  Future _handleDelete(String id) async {
    final response = await http.delete(
      Uri.parse("http://192.168.1.114:3000/tasks/$id"),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task berhasil dihapus')));
      _getData(); // Refresh list tanpa perlu push ke DashboardPage
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus task')));
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : _dataToDo.isEmpty
        ? const Center(child: Text("No tasks found"))
        : ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: _dataToDo.length,
          itemBuilder: ((context, index) {
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DetailTasks(
                            taskData: {
                              'id': _dataToDo[index]['id'],
                              'task_detail': _dataToDo[index]['task_detail'],
                              'note': _dataToDo[index]['note'],
                            },
                          ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    _dataToDo[index]['task_detail'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(_dataToDo[index]['note']),
                  trailing: SizedBox(
                    width: 96,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EditTaksPage(
                                      taskData: {
                                        'id': _dataToDo[index]['id'],
                                        'task_detail':
                                            _dataToDo[index]['task_detail'],
                                        'note': _dataToDo[index]['note'],
                                      },
                                    ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _handleDelete(_dataToDo[index]['id'].toString());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
  }
}
