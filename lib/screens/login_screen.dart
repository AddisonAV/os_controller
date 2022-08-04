import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:os_controller/utils/login_event.dart';
import 'package:os_controller/utils/providers.dart';
import 'package:event_bus/event_bus.dart';
import 'package:http/http.dart' as http;

late int userID;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  Future<bool> validateLogin(String username, String password) async {
    //await Future.delayed(const Duration(seconds: 1));
    final resp = await http.put(Uri.parse('http://localhost:9898/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "name": username,
          "password": password,
        }));

    if (resp.statusCode == 200 && resp.body != '-1') {
      userID = int.parse(resp.body);
      return true;
    } else {
      return false;
    }
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
        child: ListView(
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'OS Controller',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            )),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Sign in',
              style: TextStyle(fontSize: 20),
            )),
        Container(
          padding:
              const EdgeInsets.only(left: 200, right: 200, top: 10, bottom: 10),
          child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'User Name',
            ),
          ),
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 200, right: 200, top: 10, bottom: 10),
          child: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
        ),
        Container(
            height: 60,
            width: 100,
            padding: const EdgeInsets.only(
                left: 200, right: 200, top: 10, bottom: 10),
            child: ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                validateLogin(usernameController.text, passwordController.text)
                    .then((value) {
                  if (value) {
                    getIt<EventBus>().fire(LoginEvent(true));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              content:
                                  const Text("username or password is wrong"),
                              actions: [
                                TextButton(
                                  child: const Text("Ok"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ));
                  }
                });
              },
            )),
      ],
    ));
  }
}
