// ignore_for_file: prefer_const_constructors
import 'package:os_controller/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:os_controller/utils/task.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

//we can create more parameters if needed
Container customContainer(Widget child, {EdgeInsetsGeometry padding = const EdgeInsets.all(10), double width = 200, double height = 80}){
    return  Container(
              padding: padding,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.taskColor
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
              child: child,
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
  String cardName = "very big card name here to test something";
  String description = "";
  double borderRadius = 9;
  DateTime selectedDate = DateTime.now();
  int timeSpend = 0;
  late FocusNode focusNode;
  final TextEditingController moneyController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  int costPerHour = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap( 
        
        spacing: 10,
        children: <Widget>[
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Expanded(
            child: Wrap( children: [customContainer(Text(cardName))])
          ),
          Expanded(
            child: Wrap( children: [customContainer(Text(creationDate))])
          ),
          Expanded(
            child: Wrap(children: [customContainer(Text(lastEditedDate))])
          ),
          Expanded(
            child: Wrap(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: IconButton(
                    icon: const Icon(Icons.comment),
                    tooltip: 'Annotations',
                    onPressed: () {
                      setState(() {
                        openDialog();
                      });
                    },
                  ) 
                )
              ]
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
              child: DropdownButton<Status>(
                    value: dummyStts,
                    icon: const Icon(Icons.arrow_downward, size: 15),
                    elevation: 20,
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
                        child: Text(value.toString().split('.').last, style: TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                ),
            )
          ),
          Expanded(
            child: Wrap(
              children: [
                customContainer(
                  SizedBox(
                    height: 20,
                    width: 100,
                    child: TextField(
                      
                      style: TextStyle(fontSize: 15),
                      
                      inputFormatters: [ 
                          CurrencyTextInputFormatter(locale: 'eu', decimalDigits: 0, name: "H")
                      ],
                      textAlign: TextAlign.center,
                      controller: timeController,
                      onSubmitted: (String value) async {
                        timeSpend = int.parse(value);
                      },
                    ),
                  )  
                , padding: EdgeInsets.only(bottom: 10))
              ],
            )
          ),
          Expanded(
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
              child: TextField(
                inputFormatters: [ 
                    CurrencyTextInputFormatter(locale: 'eu', decimalDigits: 0, name: "H")
                ],
                textAlign: TextAlign.left,
                controller: timeController,
                onSubmitted: (String value) async {
                  timeSpend = int.parse(value);
                },
              ),
            )
          ),
          Expanded(
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
              child: TextField(
                inputFormatters: [CurrencyTextInputFormatter(locale: 'en', decimalDigits: 2, name: "R\$")],
                textAlign: TextAlign.center,
                controller: moneyController,
                onSubmitted: (String value) async {
                  timeSpend = int.parse(value);
                },
              ),
            )
          ),
        ]
      )
    );
  }

  Future openDialog() => showDialog(
    context: context, 
    builder: (context) => AlertDialog(
        title: Text("Annotations"),
        content: Wrap(children: [ 
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.taskColor
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
            child: TextField(
              
              keyboardType: TextInputType.multiline,
              controller: descController,
              textAlign: TextAlign.center,
              maxLines: null,
              onSubmitted: (String value) async {
                    description = value;
              }
            )
          ),
        ],
      )
    )
  );
}



