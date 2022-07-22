// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum Status { BACKLOG, WORKING, FIXING, PAPPROVAL, PPAYMANT, DONE, PAUSED }

class Task extends StatefulWidget {
  const Task({Key? key}) : super(key: key);

  @override
  State<Task> createState() => _Task();
}

class _Task extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: DataTable(
      columns: const [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Data')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Time'))
      ],
      rows: const [
        DataRow(cells: [
          DataCell(Text('JP Cornin')),
          DataCell(Text('2021-03-01')),
          DataCell(Text('Backlog')),
          DataCell(Text('Flamengo'))
        ])
      ],
    ));
  }
}
