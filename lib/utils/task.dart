// ignore_for_file: constant_identifier_names, non_constant_identifier_names, avoid_print
import 'package:intl/intl.dart';
import 'package:os_controller/utils/status.dart' as statusConnec;
import 'package:os_controller/utils/taskConnection.dart';

class Task {
  late int id;
  bool isTaskEnabled = true;
  String status = "BACKLOG";
  late DateTime creationDate;
  late String lastEditDate;
  int time = 0;
  late String name = "";
  String annotations = "";
  late double money = 0;

  Task.empty();

  Task(this.name) {
    id = DateTime.now().millisecondsSinceEpoch;
    creationDate = DateTime.now();
    lastEditDate = DateFormat.yMMMd().format(creationDate) +
        " - " +
        DateFormat.Hm().format(creationDate);
  }

  void Save() {
    taskConnection.insertTask(this);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  bool operator <(Task other) => id < other.id;

  int getId() {
    return id;
  }

  int getTime() {
    return time;
  }

  double getMoney() {
    return money;
  }

  String getLastEditedDate() {
    return lastEditDate;
  }

  DateTime getCreationDate() {
    return creationDate;
  }

  String getCreationDateFormatted() {
    return DateFormat('yyyy-MM-dd').format(creationDate);
  }

  String getCreationDateStr() {
    return DateFormat.yMMMd().format(creationDate);
  }

  String getStatus() {
    return status;
  }

  String getStatusID() {
    return statusConnec.status.findStatusID(status).toString();
  }

  String getName() {
    return name;
  }

  String getAnnotation() {
    return annotations;
  }

  void setName(String name) {
    this.name = name;
    taskConnection.update(this);
  }

  void setTime(int newTime) {
    time = newTime;
    taskConnection.update(this);
  }

  void setLastEditedDate(String newDate) {
    lastEditDate = newDate;
    taskConnection.update(this);
  }

  void setAnnotation(String newAnnotation) {
    annotations = newAnnotation;
    taskConnection.update(this);
  }

  void printTask() {
    print("-------------------");
    print("id: $id");
    print("name: $name");
    print("description: $annotations");
    print("creationDate: $creationDate");
    print("lastEditDate: $lastEditDate");
    print("time: $time");
    print("status: $status");
    print("-------------------");
  }

  void setStatus(
    String newStatus,
  ) {
    if (newStatus == "PAID") {
      isTaskEnabled = false;
    } else {
      isTaskEnabled = true;
    }
    status = newStatus;
    taskConnection.update(this);
  }

  void setData(int id, int time, String lastEditDate, DateTime creationDate,
      String name, String annotations, String newStatus) {
    this.id = id;
    this.name = name;
    this.time = time;
    this.lastEditDate = lastEditDate;
    this.creationDate = creationDate;
    this.annotations = annotations;
    if (newStatus == "PAID") {
      isTaskEnabled = false;
    } else {
      isTaskEnabled = true;
    }
    status = newStatus;
  }

  void setMoney(double newMoney) {
    money = newMoney;
  }
}
