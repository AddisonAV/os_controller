// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Status { BACKLOG, WORKING, FIXING, DONE, PAUSED }

class Task {
  Status status = Status.BACKLOG;
  late DateTime creationDate;
  late DateTime lastEditDate;
  int time = 0;
  late String name;
  late String annotations;
  late double money = 0;

  Task(this.name) {
    creationDate = DateTime.now();
    lastEditDate = creationDate;
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

  DateTime getCreationDate() {
    return creationDate;
  }

  String getLastEditedDatetimeStr() {
    return DateFormat("dd/MM/yyyy HH:mm").format(lastEditDate);
  }

  String getCreationDateStr() {
    return DateFormat("dd/MM/yyyy").format(creationDate);
  }

  Status getStatus() {
    return status;
  }

  String getName() {
    return name;
  }

  String getAnnotation() {
    return annotations;
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

  void setStatus(Status newStatus) {
    status = newStatus;
  }

  void setMoney(double newMoney) {
    money = newMoney;
  }
}
