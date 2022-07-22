import 'dart:developer';
//import 'dart:math';

import 'package:flutter/material.dart';

class CreateOSForm extends StatelessWidget {
  CreateOSForm({Key? key}) : super(key: key);

  TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('test de cu'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your name',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  // CALL DATABASE COMUNICATION HERE
                  var aux = _name.text;
                  log("name: $aux");
                },
                child: const Text('Add'))
          ],
        ));
  }
}
