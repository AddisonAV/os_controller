import 'package:os_controller/utils/task.dart';

class ChangeStatusEvent {
  final Task updated_task;

  ChangeStatusEvent(this.updated_task);

  int getEventTaskId() {
    return updated_task.id;
  }

  Status getStatus() {
    return updated_task.status;
  }
}
