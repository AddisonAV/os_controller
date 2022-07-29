import 'package:flutter/material.dart';
import 'package:os_controller/screens/home_screen.dart';
import 'package:os_controller/utils/change_status_event.dart';
//import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:os_controller/utils/providers.dart';
import 'package:event_bus/event_bus.dart';

void main() {
  setupProviders();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OS Controller',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
