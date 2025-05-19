import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeService {
  static Future<String?> checkSession() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  static Future checkBiometricUser() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'biometricLogin');
  }

  static Future checkBiometricTokenUser() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'biometricToken');
  }
}
