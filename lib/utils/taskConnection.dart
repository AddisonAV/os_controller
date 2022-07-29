import 'dart:convert';

import 'package:os_controller/utils/task.dart';
import 'package:http/http.dart' as http;

class TaskConnection {
  Future<http.Response> insertTask(Task task) {
    print(task.getId().toString());
    print(task.getName());
    print(task.getCreationDateFormatted());
    print(task.getLastEditedDateFormatted());
    print(task.getTime().toString());
    print(task.getStatusID());
    return http.post(
      Uri.parse('http://localhost:9898/subscribe'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id": task.getId().toString(),
        "name": task.getName(),
        "description": task.getAnnotation(),
        "creationDate": task.getCreationDateFormatted(),
        "lastEditDate": task.getLastEditedDateFormatted(),
        "time": task.getTime().toString(),
        "status": task.getStatusID(),
      }),
    );
  }

  void updateTask(Task task) {}
}
