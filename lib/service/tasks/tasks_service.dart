import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TasksService {
  static Future storeTasks(String taskDetail, String note) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    final response = await http.post(
      Uri.parse("http://192.168.1.114:3000/tasks"),
      headers: {'Authorization': 'Bearer $token'},
      body: {'task_detail': taskDetail, 'note': note},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
