import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("http://192.168.1.114:3000/auth/login"),
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final id = data['data']['id'];
      final name = data['data']['name'];
      final username = data['data']['username'];
      final biometricLogin = data['data']['biometricLogin'];
      final biometricToken = data['data']['biometricToken'];

      final storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: token);
      await storage.write(key: 'id', value: id);
      await storage.write(key: 'name', value: name);
      await storage.write(key: 'username', value: username);
      await storage.write(
        key: 'biometricLogin',
        value: biometricLogin.toString(),
      );
      await storage.write(key: 'biometricToken', value: biometricToken);

      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final storage = FlutterSecureStorage();
    return await storage.delete(key: 'token');
  }
}
