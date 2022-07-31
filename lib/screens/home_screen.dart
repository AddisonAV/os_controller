import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:os_controller/ui/colors.dart';
import 'package:os_controller/utils/StatusChangeNotifier.dart';
import 'package:os_controller/utils/dataLoadEvent.dart';
import 'package:os_controller/utils/task.dart';
import 'package:os_controller/widgets/task_widget.dart';
import 'package:os_controller/utils/providers.dart';
import 'package:event_bus/event_bus.dart';
import 'package:os_controller/utils/change_status_event.dart';
import 'package:os_controller/utils/status.dart';
import 'package:os_controller/utils/StatusChangeNotifier.dart';

// ignore: non_constant_identifier_names
bool initial_load = false;

Container tContainer(String title, Widget child) {
  return Container(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: child,
    ),
  );
}

List<Widget> buildTaskList(Map<String, List<TaskWidget>> tasks) {
  List<Widget> widgets = [];

  // ignore: non_constant_identifier_names
  for (String Status in status.StatusList) {
    if (tasks[Status] != null && tasks[Status]!.isNotEmpty) {
      widgets.add(const SizedBox(height: 30));
      widgets.add(
        Container(
          color: AppColor.primaryColor,
          child: Text(
            Status,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      );
      widgets.add(
        tContainer(
            Status,
            Column(
              children: tasks[Status]!,
            )),
      );
    }
  }
  return widgets;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController descController = TextEditingController(),
      newOSController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Widget _body = CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    status.getAllStatus();

    getIt<EventBus>().on<DataLoadEvent>().listen((event) {
      if (event.getEventResult()) {
        taskUpdater.updateTaskMap();
      }
    });

    return Scaffold(
        backgroundColor: AppColor.primaryColor,
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 50,
          backgroundColor: AppColor.primaryColor,
          centerTitle: true,
          title: const Text("Ovo do breno"),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 35, bottom: 5),
              onPressed: () {
                openDialog();
              },
              icon: const Icon(
                Icons.playlist_add_circle_outlined,
                size: 45,
              ),
              hoverColor: Colors.transparent,
              tooltip: "Add new OS",
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 20, right: 200, left: 200),
          child: ValueListenableBuilder(
            valueListenable: taskUpdater.tasksMap,
            builder: (context, Map<String, List<TaskWidget>> _tasks, child) =>
                Column(children: buildTaskList(_tasks)),
          ),
        )));
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            content: Stack(
              children: <Widget>[
                Positioned(
                  right: -5,
                  top: -5,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.close,
                        size: 15,
                      ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Create new OS",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 4,
                            child: TextField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(60)
                              ],
                              controller: newOSController,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: "Enter os Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onChanged: (value) {},
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Text("Create OS"),
                          onPressed: () {
                            Task task = Task(newOSController.text);
                            taskUpdater.addTask(task);
                            task.Save();
                            taskUpdater.printTaskMap();
                            newOSController.clear();
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));
}
