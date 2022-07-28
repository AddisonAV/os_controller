// ignore_for_file: prefer_const_constructors
import 'package:os_controller/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:os_controller/utils/task.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

//we can create more parameters if needed
Container customContainer(Widget child,
    {EdgeInsetsGeometry padding = const EdgeInsets.all(10),
    double width = 200,
    double height = 80}) {
  return Container(
    padding: padding,
    decoration: BoxDecoration(
      border: Border.all(color: AppColor.taskColor),
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
  Task task = Task("Os bem maneira");
  double borderRadius = 9;
  late FocusNode focusNode;
  final TextEditingController moneyController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  int costPerHour = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Wrap(spacing: 10, children: <Widget>[
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Expanded(
              child: Wrap(children: [customContainer(Text(task.getName()))])),
          Expanded(
              child: Wrap(children: [
            customContainer(Text(task.getCreationDateStr()))
          ])),
          Expanded(
              child: Wrap(children: [
            customContainer(Text(task.getLastEditedDatetimeStr()))
          ])),
          Expanded(
            child: Wrap(children: [
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
                  ))
            ]),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
            child: DropdownButton<Status>(
              value: task.getStatus(),
              icon: const Icon(Icons.arrow_downward, size: 15),
              elevation: 20,
              style: TextStyle(color: AppColor.taskColor),
              underline: Container(
                height: 1,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (Status? newValue) {
                setState(() {
                  task.setStatus(newValue!);
                });
              },
              items: <Status>[
                Status.BACKLOG,
                Status.WORKING,
                Status.FIXING,
                Status.DONE,
                Status.PAUSED
              ].map<DropdownMenuItem<Status>>((Status value) {
                return DropdownMenuItem<Status>(
                  value: value,
                  child: Text(value.toString().split('.').last,
                      style: TextStyle(fontSize: 13)),
                );
              }).toList(),
            ),
          )),
          Expanded(
              child: Wrap(
            children: [
              customContainer(
                  SizedBox(
                    height: 20,
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration.collapsed(hintText: '0 H'),
                      style: TextStyle(fontSize: 15),
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                            locale: 'eu', decimalDigits: 0, name: "H")
                      ],
                      textAlign: TextAlign.center,
                      controller: timeController,
                      onSubmitted: (String value) async {
                        task.setTime(int.parse(value));
                      },
                    ),
                  ),
                  padding:
                      EdgeInsets.only(bottom: 3, left: 10, right: 10, top: 13))
            ],
          )),
          Expanded(
              child: Wrap(
            children: [
              customContainer(
                  SizedBox(
                    height: 20,
                    width: 100,
                    child: TextField(
                      decoration:
                          InputDecoration.collapsed(hintText: 'R\$ 0.00'),
                      style: TextStyle(fontSize: 15),
                      inputFormatters: [
                        CurrencyTextInputFormatter(
                            locale: 'en', decimalDigits: 2, name: "R\$")
                      ],
                      textAlign: TextAlign.center,
                      controller: moneyController,
                      onSubmitted: (String value) async {
                        task.setMoney(double.parse(value));
                      },
                    ),
                  ),
                  padding:
                      EdgeInsets.only(bottom: 3, left: 10, right: 10, top: 13))
            ],
          )),
        ]));
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
              content: Wrap(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkResponse(
                  onTap: () {
                    descController.text = task.getAnnotation();
                    Navigator.of(context).pop();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.close,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Annotations',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.taskColor),
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
                        descController.text = task.getAnnotation();
                      })),
              Center(
                child: ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () {
                    task.setAnnotation(descController.text);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          )));
}
