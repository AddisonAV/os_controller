// ignore_for_file: prefer_const_constructors
import 'package:os_controller/ui/colors.dart';
import 'dart:html';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:os_controller/utils/task.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';

//we can create more parameters if needed
TitledContainer createContainer(String text, String title, {double width = 200}){
    return  TitledContainer(
            
            titleColor: AppColor.taskColor,
            title: title,
            textAlign: TextAlignTitledContainer.Left,
            fontSize: 16.0,
            backgroundColor: AppColor.primaryColor,
            child: Container(
              padding: EdgeInsets.all(20),
              width: width,
              height: 80.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.taskColor
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
              child: Center(
                child: Text(
                  text,
                  //style: TextStyle(fontSize: 28.0),
                ),
              ),
            ),
          );

}

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key}) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidget();
}

class _TaskWidget extends State<TaskWidget> {
  late Task task;
  Status dummyStts = Status.BACKLOG;
  String creationDate = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String lastEditedDate = DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now());
  String cardName = "Card Name";
  double borderRadius = 9;
  DateTime selectedDate = DateTime.now();

  late FocusNode focusNode;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap( 
        
        spacing: 10,
        children: <Widget>[
          //const FlutterLogo(size: 100),
          const SizedBox(height: 10),
          //const Text('DateField package showcase'),
          const Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Expanded(
            child: createContainer(cardName, "")
          ),
          Expanded(
            child: createContainer( lastEditedDate, "Last edit ")
          ),
          Expanded(
            child: createContainer(creationDate, " Created at"),
          ),

          Expanded(
            
            child: TitledContainer(
              titleColor: AppColor.taskColor,
              title: "Status",
              textAlign: TextAlignTitledContainer.Left,
              fontSize: 16.0,
              backgroundColor: AppColor.primaryColor,
              child: Container(
                padding: EdgeInsets.all(20),
                width: 200,
                height: 80.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.taskColor
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(9),
                    ),
                  ),
                  child: DropdownButton<Status>(
                    value: dummyStts,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: TextStyle(color: AppColor.taskColor),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (Status? newValue) {
                      setState(() {
                        dummyStts = newValue!;
                      });
                    },
                    items: <Status>[Status.BACKLOG, Status.WORKING, Status.FIXING, Status.DONE,Status.PAUSED]
                        .map<DropdownMenuItem<Status>>((Status value) {
                      return DropdownMenuItem<Status>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                )
              )
          )
            )
            
        ],
      )
    );
  }
}
