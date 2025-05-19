import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
  // get all username user
  static Future getAllUsernameUser() async {
    final response = await http.get(
      Uri.parse("http://192.168.1.114:3000/users"),
    );

    if (response.statusCode == 200) {
      jsonDecode(response.body);
      final data = jsonDecode(response.body);
      return data['data']['username'];
    }
  }

  // get all user
  static Future<void> getAllUser() async {
    final response = await http.get(
      Uri.parse("http://192.168.1.114:3000/users"),
    );

    if (response.statusCode == 200) {
      jsonDecode(response.body);
      final data = jsonDecode(response.body);
      return data['data'];
    }
  }

  // get one user
  static Future<void> getUser(String id) async {
    final response = await http.get(
      Uri.parse("http://192.168.1.114:3000/users/$id"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    }
  }

  // create user
  static Future<bool> signup(
    String name,
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("http://192.168.1.114:3000/users"),
      body: {'name': name, 'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      jsonDecode(response.body);
      final storage = FlutterSecureStorage();
      await storage.delete(key: 'biometricLogin');
      await storage.delete(key: 'biometricToken');
      return true;
    } else {
      return false;
    }
  }
}
