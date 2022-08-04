// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:os_controller/utils/task.dart';
import 'package:os_controller/utils/status.dart';
import 'package:os_controller/utils/taskConnection.dart';
import 'package:os_controller/widgets/task_widget.dart';

class TaskUpdater extends ChangeNotifier {
  late ValueNotifier<List<Task>> tasks = ValueNotifier([]);

  final ValueNotifier<Map<String, List<TaskWidget>>> tasksMap =
      ValueNotifier({});

  TaskUpdater() {
    taskConnection.getTasks().then((value) {
      tasks = ValueNotifier(taskConnection.tasks);
      updateTaskMap();
    });
  }

  void createMap() {
    tasksMap.value = {
      "BACKLOG": [],
      "WORKING": [],
      "FIXING": [],
      "DONE": [],
      "PAUSED": [],
      "PAID": [],
    };
  }

  void updateTaskMap() {
    tasksMap.value = {
      "BACKLOG": [],
      "WORKING": [],
      "FIXING": [],
      "DONE": [],
      "PAUSED": [],
      "PAID": [],
    };
    for (Task task in tasks.value) {
      tasksMap.value[task.status]!.add(TaskWidget(task));
    }

    notifyListeners();
  }

  void addTask(Task task) {
    tasks.value.add(task);
    updateTaskMap();
    notifyListeners();
  }

  void removeTask(Task task) {
    tasks.value.remove(task);
    updateTaskMap();
    notifyListeners();
  }

  void printTaskMap() {
    for (String stats in status.statusList) {
      print(stats);
      for (TaskWidget taskW in tasksMap.value[stats]!) {
        print(taskW.task.id);
      }
    }
  }

  void updateTask(Task task) {
    for (Task taskAux in tasks.value) {
      if (taskAux.id == task.id) {
        taskAux.setStatus(task.status);
        break;
      }
    }
    updateTaskMap();
    notifyListeners();
  }
}

TaskUpdater taskUpdater = TaskUpdater();
