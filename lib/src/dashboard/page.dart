import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:todolist/main.dart';
import 'package:todolist/service/dashboard/dashboard_service.dart';
import 'package:todolist/src/dashboard/list_layout.dart';
import 'package:todolist/src/settings/page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? name;
  int selected = 0;

  Future _handleUser() async {
    final nameUser = await DashboardService.getUserLogin();
    setState(() {
      name = nameUser;
    });
  }

  @override
  void initState() {
    _handleUser();
    super.initState();
  }

  NavigationRailAlignment alignment = NavigationRailAlignment.start;
  NavigationLabelType labelType = NavigationLabelType.none;
  NavigationLabelPosition labelPosition = NavigationLabelPosition.bottom;
  bool customButtonStyle = false;
  bool expanded = true;

  NavigationItem buildButton(String label, IconData icon) {
    return NavigationItem(
      style:
          customButtonStyle
              ? const ButtonStyle.muted(density: ButtonDensity.icon)
              : null,
      selectedStyle:
          customButtonStyle
              ? const ButtonStyle.fixed(density: ButtonDensity.icon)
              : null,
      label: Text(label),
      child: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: [
        AppBar(
          title: const Text("Todolist"),
          subtitle: Text(selected == 0 ? "Your to do" : "Settings"),
          leading: [
            OutlineButton(
              density: ButtonDensity.icon,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(title: "Todolist"),
                  ),
                );
              },
              child: const Icon(Icons.arrow_back),
            ),
          ],
          trailing: [Text(name ?? '', style: TextStyle(fontSize: 15))],
        ),
      ],
      child: Row(
        children: [
          NavigationRail(
            alignment: alignment,
            labelType: labelType,
            index: selected,
            labelPosition: labelPosition,
            expanded: expanded,
            onSelected: (index) {
              setState(() {
                selected = index;
              });
            },
            children: [
              const NavigationLabel(child: Text('Dashboard')),
              buildButton('Home', BootstrapIcons.house),
              const NavigationDivider(),
              const NavigationLabel(child: Text('Settings')),
              buildButton('Service', BootstrapIcons.gear),
            ],
          ),
          const VerticalDivider(),
          if (selected == 0) Expanded(child: ListLayout()),
          if (selected == 1) Expanded(child: SettingsPage()),
        ],
      ),
    );
  }
}
