import 'dart:convert';

import 'package:os_controller/utils/providers.dart';
import 'package:os_controller/utils/status.dart';
import 'package:os_controller/utils/task.dart';
import 'package:http/http.dart' as http;
import 'package:os_controller/utils/tasksLoadEvent.dart';
import 'package:event_bus/event_bus.dart';

class TaskConnection {
  List<Task> tasks = [];
  late TaskLoadEvent taskLoadEvent;

  Future<http.Response> insertTask(Task task) {
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

  Future<http.Response> deleteTask(Task task) async {
    final resp = await http.delete(Uri.parse('http://localhost:9898/delete'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id": task.getId().toString(),
        }));

    if (resp.statusCode == 200) {
      return resp;
    } else {
      throw Exception('Failed to delete task');
    }
  }

  Future getTasks() async {
    final response = await http.get(Uri.parse('http://localhost:9898/tasks'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      taskLoadEvent = TaskLoadEvent(true);
      for (var aux in jsonData) {
        Task task = Task.empty();
        task.setData(
            aux['id'],
            aux['time'],
            DateTime.parse(aux['lastEditDate']),
            DateTime.parse(aux['creationDate']),
            aux['name'],
            aux['description'],
            status.findStatus(aux['status'].toString()));
        tasks.add(task);
      }
    } else {
      taskLoadEvent = TaskLoadEvent(false);
      throw Exception('Failed to load tasks');
    }
    getIt<EventBus>().fire(taskLoadEvent);
  }

  Future<http.Response> update(Task task) {
    return http.put(
      Uri.parse('http://localhost:9898/update'),
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
}

TaskConnection taskConnection = TaskConnection();
