// ignore_for_file: prefer_const_constructors

import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:os_controller/utils/task.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key}) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidget();
}

class _TaskWidget extends State<TaskWidget> {
  late Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Color.fromARGB(255, 226, 226, 226)),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Geeks",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.green),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Geeks",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
