import 'package:flutter/cupertino.dart';
import 'package:os_controller/utils/task.dart';
import 'package:os_controller/utils/status.dart';
import 'package:os_controller/widgets/task_widget.dart';

class TaskUpdater extends ChangeNotifier {
  final ValueNotifier<List<Task>> tasks =
      ValueNotifier([Task('Task 1', 0), Task('Task 2', 1), Task('Task 3', 2)]);

  final ValueNotifier<Map<String, List<TaskWidget>>> tasksMap = ValueNotifier({
    "BACKLOG": [],
    "WORKING": [],
    "FIXING": [],
    "DONE": [],
    "PAUSED": [],
    "PAID": [],
  });
  TaskUpdater() {
    updateTaskMap();
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
  }

  void addTask(Task task) {
    tasks.value.add(task);
    updateTaskMap();
    notifyListeners();
  }

  void printTaskMap() {
    for (String stats in status.StatusList) {
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
