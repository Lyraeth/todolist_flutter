import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:todolist/service/auth/auth_service.dart';
import 'package:todolist/service/home/home_service.dart';
import 'package:todolist/service/noti_service.dart';
import 'package:todolist/src/auth/login/page.dart';
import 'package:todolist/src/auth/signup/page.dart';
import 'package:todolist/src/dashboard/page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'Todolist',
      home: MyHomePage(title: "Todolist"),
      theme: ThemeData(colorScheme: ColorSchemes.darkZinc(), radius: 0.5),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final LocalAuthentication auth;
  String? _session;
  String? _biometric;
  String? _biometricToken;

  Future<void> _loadSession() async {
    final token = await HomeService.checkSession();
    final biometric = await HomeService.checkBiometricUser();
    final biometricToken = await HomeService.checkBiometricTokenUser();

    setState(() {
      _session = token;
      _biometric = biometric;
      _biometricToken = biometricToken;
    });
  }

  Future _removeSession() async {
    await AuthService.logout();
    _loadSession();
  }

  Future<void> _initNotification() async {
    await NotiService().init();
  }

  @override
  void initState() {
    super.initState();
    _initNotification();
    auth = LocalAuthentication();
    _loadSession();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_session == null)
            Column(
              children: [
                const Text(
                  "Welcome to Todolist",
                  style: TextStyle(fontSize: 25),
                ).semiBold(),
                SizedBox(height: 10),
                const Text(
                  "Login first to access your dashboard",
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(height: 20),
                const SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [Divider()],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlineButton(
                      onPressed:
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          ),
                      child: const Text("Login"),
                    ),
                    if (_biometric == "true" && _biometricToken != null)
                      OutlineButton(
                        onPressed: () async {
                          await _authenticated().then((_) => _loadSession());
                        },
                        child: const Icon(Icons.fingerprint),
                      ),
                    OutlineButton(
                      onPressed:
                          () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          ),
                      child: const Text("Signup"),
                    ),
                  ],
                ),
              ],
            )
          else
            Column(
              children: [
                const Text(
                  "Welcome back!",
                  style: TextStyle(fontSize: 25),
                ).semiBold(),
                SizedBox(height: 10),
                const Text("You're logged in", style: TextStyle(fontSize: 10)),
                SizedBox(height: 20),
                const SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [Divider()],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlineButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardPage(),
                          ),
                        );
                      },
                      child: const Text("Dashboard"),
                    ),
                    OutlineButton(
                      onPressed: _removeSession,
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _authenticated() async {
    try {
      final storage = FlutterSecureStorage();
      final biometric = await storage.read(key: 'biometricLogin');
      final biometricToken = await storage.read(key: 'biometricToken');

      // hanya lanjut fingerprint kalau biometricLogin true dan biometricToken ada
      if (biometric == 'true' && biometricToken != null) {
        final authenticated = await auth.authenticate(
          localizedReason: "Authenticate to access your Dashboard",
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );

        if (authenticated) {
          await storage.write(key: 'token', value: biometricToken);
          await _loadSession();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        }
      } else {
        showToast(
          context: context,
          builder:
              (context, overlay) => SurfaceCard(
                child: Basic(
                  title: const Text('Fingerprint disabled or token missing'),
                  trailing: PrimaryButton(
                    size: ButtonSize.small,
                    onPressed: overlay.close,
                    child: const Text('OK'),
                  ),
                ),
              ),
        );
      }
    } on PlatformException catch (e) {
      print("Fingerprint error: $e");
    }
  }
}
