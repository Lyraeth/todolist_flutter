import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool value = false;

  Future _getBiometric() async {
    final storage = FlutterSecureStorage();
    final biometric = await storage.read(key: 'biometricLogin');

    setState(() {
      value = biometric == 'true';
    });
  }

  Future _editBiometricUser(bool biometricLogin) async {
    final storage = FlutterSecureStorage();
    final id = await storage.read(key: 'id');
    final token = await storage.read(key: 'token');

    final response = await http.put(
      Uri.parse("http://192.168.1.114:3000/users/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'biometricLogin': biometricLogin}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final biometric = data['data']['biometricLogin'];

      await storage.write(key: 'biometricLogin', value: biometric.toString());

      showToast(
        context: context,
        builder: (context, overlay) => buildToast(context, overlay, 'Saved!'),
        location: ToastLocation.bottomLeft,
      );

      return true;
    } else {
      showToast(
        context: context,
        builder:
            (context, overlay) => buildToast(
              context,
              overlay,
              'Failed to update fingerprint setting',
            ),
        location: ToastLocation.bottomRight,
      );
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getBiometric();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: const Text("User Setting"),
        ),
        Divider(),
      ],
      footers: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: OutlineButton(
            child: const Text("Submit"),
            onPressed: () async {
              await _editBiometricUser(value).then((_) => _getBiometric());
            },
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Enable fingerprint login?"),
              Switch(
                value: value,
                onChanged: (value) {
                  setState(() {
                    this.value = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildToast(
    BuildContext context,
    ToastOverlay overlay,
    String message,
  ) {
    return SurfaceCard(
      child: Basic(
        title: Text(message),
        trailing: PrimaryButton(
          size: ButtonSize.small,
          onPressed: () {
            overlay.close();
          },
          child: const Text('Undo'),
        ),
        trailingAlignment: Alignment.center,
      ),
    );
  }
}
