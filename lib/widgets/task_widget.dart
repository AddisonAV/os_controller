// ignore_for_file: prefer_const_constructors

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:os_controller/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:os_controller/utils/dataLoadEvent.dart';
import 'package:os_controller/utils/providers.dart';
import 'package:os_controller/utils/task.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:os_controller/utils/status.dart';
import 'package:event_bus/event_bus.dart';
import 'package:os_controller/utils/StatusChangeNotifier.dart';
import 'package:os_controller/utils/tasksLoadEvent.dart';

//we can create more parameters if needed
Container customContainer(Widget child,
    {EdgeInsetsGeometry padding = const EdgeInsets.all(15),
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
  final Task task;
  const TaskWidget(this.task, {Key? key}) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidget();
}

class _TaskWidget extends State<TaskWidget> {
  double borderRadius = 9;
  late FocusNode focusNode;
  final TextEditingController moneyController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastEditedController = TextEditingController();

  void initializeWidget() {
    nameController.text = widget.task.name;
    timeController.text = widget.task.time.toString() + " H";
    moneyController.text =
        "R\$" + (widget.task.time * costPerHour).toString() + ".00";
    descController.text = widget.task.annotations;
    lastEditedController.text = widget.task.getLastEditedDatetimeStr();
  }

  int costPerHour = 20;

  void updateMoney(String value) {
    if (value != "") {
      int auxVal = int.parse(value.replaceAll(RegExp(r'[^0-9]'), ''));

      widget.task.setTime(auxVal);
      moneyController.text = "R\$" + (auxVal * costPerHour).toString() + ".00";
    }
  }

  void updateLastEdited() {
    lastEditedController.text = DateFormat.yMMMd().format(DateTime.now()) +
        " " +
        DateFormat.Hm().format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    initializeWidget();
    getIt<EventBus>().on<DataLoadEvent>().listen((event) {
      if (event.getEventResult()) {
        setState(() {});
      }
    });
    getIt<EventBus>().on<TaskLoadEvent>().listen((event) {
      if (event.getEventResult()) {
        setState(() {});
      }
    });
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(children: <Widget>[
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Expanded(
            child: customContainer(
                TextField(
                    enabled: widget.task.isTaskEnabled,
                    inputFormatters: [LengthLimitingTextInputFormatter(60)],
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Nome da tarefa",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                    controller: nameController,
                    onChanged: (String value) async {
                      updateLastEdited();
                      widget.task.setName(value);
                    }),
                padding: EdgeInsets.all(0)),
          ),
          Expanded(
            child: customContainer(
              Text(
                lastEditedController.text,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: customContainer(
              Text(
                widget.task.getCreationDateStr(),
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(4),
                  child: IconButton(
                    icon: const Icon(Icons.comment),
                    tooltip: 'Annotations',
                    onPressed: () {
                      setState(() {
                        openDialog();
                      });
                    },
                  ))),
          Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                height: 50,
                width: 100,
                child: DropdownButton(
                  value: widget.task.getStatus(),
                  icon: const Icon(Icons.arrow_downward, size: 15),
                  elevation: 20,
                  style: TextStyle(color: AppColor.taskColor),
                  underline: Container(
                    height: 1,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      widget.task.setStatus(newValue as String);
                      taskUpdater.updateTask(widget.task);
                      //getIt<EventBus>().fire(ChangeStatusEvent(task));
                      updateLastEdited();
                    });
                  },
                  items: status.dataStatus.map((list) {
                    return DropdownMenuItem(
                      value: list['status'],
                      child: Text(list['status'].toString().split('.').last,
                          style: TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                ),
              )),
          Expanded(
              child: customContainer(
                  TextField(
                    enabled: widget.task.isTaskEnabled,
                    maxLines: null,
                    decoration: InputDecoration.collapsed(hintText: '0 H'),
                    style: TextStyle(fontSize: 15),
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                          locale: 'eu', decimalDigits: 0, name: "H")
                    ],
                    textAlign: TextAlign.center,
                    controller: timeController,
                    onChanged: (String value) async {
                      updateLastEdited();
                      updateMoney(value);
                    },
                  ),
                  padding: EdgeInsets.all(20))),
          Expanded(
            child: customContainer(
                TextField(
                  maxLines: null,
                  enabled: false,
                  decoration: InputDecoration.collapsed(hintText: 'R\$ 0.00'),
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                  controller: moneyController,
                ),
                padding: EdgeInsets.all(20)),
          )
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
                    descController.text = widget.task.getAnnotation();
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
                        descController.text = widget.task.getAnnotation();
                      })),
              Center(
                child: ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () {
                    widget.task.setAnnotation(descController.text);
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          )));
}
