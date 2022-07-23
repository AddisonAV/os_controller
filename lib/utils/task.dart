// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

enum Status { BACKLOG, WORKING, FIXING, DONE, PAUSED }

class Task {
  Status status = Status.BACKLOG;
  late DateTime creationDate;
  late DateTime lastEditDate;
  int time = 0;
  late String name;
  late String description;

  Task(this.name, this.description) {
    creationDate = DateTime.now();
    lastEditDate = creationDate;
  }

  int getTime() {
    return time;
  }

  DateTime getLastEditedDate() {
    return lastEditDate;
  }

  DateTime getCreationDate() {
    return creationDate;
  }

  Status getStatus() {
    return status;
  }

  String getName() {
    return name;
  }

  String getDescription() {
    return description;
  }

  void setTime(int newTime) {
    time = newTime;
  }

  void setLastEditedDate(DateTime newDate) {
    lastEditDate = newDate;
  }

  void setDescription(String newDesc) {
    description = newDesc;
  }

  void setStatus(Status newStatus) {
    status = newStatus;
  }
}
