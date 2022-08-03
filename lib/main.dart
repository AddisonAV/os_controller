import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:os_controller/screens/home_screen.dart';
import 'package:os_controller/screens/login_screen.dart';
import 'package:os_controller/utils/change_status_event.dart';
import 'package:os_controller/utils/login_event.dart';
//import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:os_controller/utils/providers.dart';
import 'package:event_bus/event_bus.dart';

void main() {
  setupProviders();
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _App createState() => _App();
}

class _App extends State<App> {
  Widget _home = LoginScreen();

  @override
  Widget build(BuildContext context) {
    getIt<EventBus>().on<LoginEvent>().listen((event) {
      _home = const HomeScreen();
      setState(() {});
    });
    return MaterialApp(
      title: 'OS Controller',
      theme: ThemeData.dark(),
      home: _home,
      debugShowCheckedModeBanner: false,
    );
  }
}
