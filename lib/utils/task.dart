// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:intl/intl.dart';
import 'package:os_controller/utils/status.dart' as statusConnec;
import 'package:os_controller/utils/taskConnection.dart';

//enum Status { BACKLOG, WORKING, FIXING, DONE, PAUSED, PAID }

class Task {
  late int id;
  bool isTaskEnabled = true;
  String status = "BACKLOG";
  late DateTime creationDate;
  late DateTime lastEditDate;
  int time = 0;
  late String name;
  String annotations = "";
  late double money = 0;

  Task(this.name) {
    id = DateTime.now().millisecondsSinceEpoch;
    creationDate = DateTime.now();
    lastEditDate = creationDate;
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

  DateTime getLastEditedDate() {
    return lastEditDate;
  }

  String getLastEditedDateFormatted() {
    return '${lastEditDate.year}-${lastEditDate.month}-${lastEditDate.day}';
  }

  DateTime getCreationDate() {
    return creationDate;
  }

  String getCreationDateFormatted() {
    return DateFormat('yyyy-MM-dd').format(creationDate);
  }

  String getLastEditedDatetimeStr() {
    return '${creationDate.year}-${creationDate.month}-${creationDate.day}';
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
  }

  void setTime(int newTime) {
    time = newTime;
  }

  void setLastEditedDate(DateTime newDate) {
    lastEditDate = newDate;
  }

  void setAnnotation(String newAnnotation) {
    annotations = newAnnotation;
  }

  void setStatus(String newStatus) {
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
