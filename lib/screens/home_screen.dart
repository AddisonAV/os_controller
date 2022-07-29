import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:os_controller/ui/colors.dart';
import 'package:os_controller/utils/dataLoadEvent.dart';
import 'package:os_controller/utils/task.dart';
import 'package:os_controller/widgets/task_widget.dart';
import 'package:os_controller/utils/providers.dart';
import 'package:event_bus/event_bus.dart';
import 'package:os_controller/utils/change_status_event.dart';
import 'package:os_controller/utils/status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController descController = TextEditingController(),
      newOSController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ValueNotifier<List<Task>> tasks =
      ValueNotifier([Task('Task 1'), Task('Task 2'), Task('Task 3')]);

  ValueNotifier<Map<String, List<Task>>> tasksMap = ValueNotifier({
    "BACKLOG": [],
    "WORKING": [],
    "FIXING": [],
    "DONE": [],
    "PAUSED": [],
    "PAID": [],
  });

  void printTaskMap() {
    for (String status in status.StatusList) {
      for (Task task in tasksMap.value[status]!) {
        print(task.name);
      }
    }
  }

  void updateTaskMap() {
    for (String status in status.StatusList) {
      tasksMap.value[status] =
          tasks.value.where((task) => task.status == status).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    getIt<EventBus>().on<DataLoadEvent>().listen((event) {
      if (event.getEventResult()) {
        print(status.StatusList);
        updateTaskMap();
        setState(() {});
      }
    });

    updateTaskMap();
    getIt<EventBus>().on<ChangeStatusEvent>().listen((event) {
      for (Task task in tasks.value) {
        if (task.id == event.getEventTaskId()) {
          task.setStatus(event.getStatus());
          break;
        }
      }
      //setState(() {});
    });

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        title: const Text("Ovo do breno"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  openDialog();
                });
              },
              icon: const Icon(Icons.plus_one_outlined))
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: tasksMap,
        builder: (context, Map<String, List<Task>> _tasks, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _tasks["BACKLOG"]?.length,
                  itemBuilder: (context, index) {
                    return TaskWidget(_tasks["BACKLOG"]![index].name,
                        _tasks["BACKLOG"]![index].id);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
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
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Text("Create OS"),
                          onPressed: () {
                            Task newTask = Task(newOSController.text);
                            tasks.value.add(newTask);
                            newTask.Save();
                            updateTaskMap();
                            setState(() {});
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
