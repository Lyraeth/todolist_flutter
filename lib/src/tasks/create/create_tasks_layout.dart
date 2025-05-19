import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:todolist/src/dashboard/page.dart';
import 'package:todolist/src/tasks/create/create_tasks_input.dart';

class CreateTasks extends StatefulWidget {
  const CreateTasks({super.key});

  @override
  State<CreateTasks> createState() => _CreateTasksState();
}

class _CreateTasksState extends State<CreateTasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          title: const Text("Todolist"),
          subtitle: const Text("Add tasks"),
          leading: [
            OutlineButton(
              density: ButtonDensity.icon,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
              child: const Icon(Icons.arrow_back),
            ),
          ],
        ),
      ],
      child: CreateTasksInput(),
    );
  }
}
