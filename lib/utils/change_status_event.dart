import 'package:os_controller/utils/task.dart';

class ChangeStatusEvent {
  // ignore: non_constant_identifier_names
  final Task updated_task;

  ChangeStatusEvent(this.updated_task);

  int getEventTaskId() {
    return updated_task.id;
  }

  String getStatus() {
    return updated_task.status;
  }
}
