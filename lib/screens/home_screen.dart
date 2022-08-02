import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:os_controller/ui/colors.dart';
import 'package:os_controller/utils/StatusChangeNotifier.dart';
import 'package:os_controller/utils/task.dart';
import 'package:os_controller/widgets/task_widget.dart';
import 'package:os_controller/utils/status.dart';
import 'package:os_controller/utils/upperCaseFormatter.dart';
import 'package:expandable/expandable.dart';

// ignore: non_constant_identifier_names
bool initial_load = false;

Widget createList(context, String title, Widget child, int size) {
  return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Container(
          decoration: BoxDecoration(color: AppColor.expandableColor),
          padding: const EdgeInsets.all(10),
          child: ExpandableNotifier(
            initialExpanded: false,
            child: ExpandablePanel(
              header: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    size.toString(),
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              collapsed: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: AppColor.expandableColor),
                child: const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                  child: SizedBox(
                    width: 0,
                    height: 0,
                  ),
                ),
              ),
              expanded: child,
              theme: const ExpandableThemeData(
                  tapHeaderToExpand: true,
                  tapBodyToExpand: false,
                  tapBodyToCollapse: false,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  hasIcon: true,
                  iconColor: Colors.white,
                  expandIcon: Icons.arrow_downward_rounded,
                  iconPlacement: ExpandablePanelIconPlacement.left),
            ),
          )));
}

Container tContainer(String title, Widget child) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.blue,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
    child: child,
  );
}

List<Widget> buildTaskList(context, Map<String, List<TaskWidget>> tasks) {
  List<Widget> widgets = [];

  // ignore: non_constant_identifier_names
  for (String Status in status.statusList) {
    if (tasks[Status] != null) {
      widgets.add(createList(context, Status, Column(children: tasks[Status]!),
          tasks[Status]!.length));
      widgets.add(const SizedBox(height: 10));
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
      newOSController = TextEditingController(),
      newStatusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    status.getAllStatus().then((value) => taskUpdater.createMap());

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
          toolbarHeight: 70,
          elevation: 50,
          backgroundColor: AppColor.primaryColor,
          centerTitle: true,
          title: const Text(
            "OS Controller",
            style: TextStyle(fontFamily: "Oswald", fontSize: 30),
          ),
          actions: [
            IconButton(
              iconSize: 50,
              padding: const EdgeInsets.only(right: 35, bottom: 5),
              onPressed: () {
                openNewTaskDialog();
              },
              icon: const Icon(Icons.add_circle_outline_rounded),
              /*icon: const Image(
                image: AssetImage('../data/icons/add_1.png'),
              )*/
              hoverColor: Colors.transparent,
              tooltip: "Add new Task",
            ),
            /*IconButton(
              padding: const EdgeInsets.only(right: 35, bottom: 5),
              onPressed: () {
                openNewStatusDialog();
              },
              icon: const Icon(
                Icons.playlist_add_circle_outlined,
                size: 45,
              ),
              hoverColor: Colors.transparent,
              tooltip: "Add new Status",
            )*/
          ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: ValueListenableBuilder(
            valueListenable: taskUpdater.tasksMap,
            builder: (context, Map<String, List<TaskWidget>> _tasks, child) =>
                Column(children: buildTaskList(context, _tasks))),
      ),
    );
  }

  Future openNewTaskDialog() => showDialog(
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
                          "Create new Task",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
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
                                hintText: "Task Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Text("Create Task"),
                          onPressed: () {
                            Task task = Task(newOSController.text);
                            taskUpdater.addTask(task);
                            task.Save();
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

  Future openNewStatusDialog() => showDialog(
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
                          "Create new Status",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 4,
                            child: TextField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                UpperCaseTextFormatter()
                              ],
                              controller: newStatusController,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: "Status Name",
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
                          child: const Text("Create Status"),
                          onPressed: () {
                            if (status.addStatus(newStatusController.text)) {
                              newStatusController.clear();
                              Navigator.of(context).pop();
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        content:
                                            const Text("Status already exists"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Ok"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ));
                            }
                            ;
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
