import 'package:flutter/material.dart';
import 'package:os_controller/screens/create_os.dart';
import 'package:os_controller/ui/colors.dart';
import 'package:os_controller/utils/task.dart';
import 'package:os_controller/widgets/task_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController descController = TextEditingController(),
      newOSController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Widget showOsTable() {
    return TaskWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.primaryColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColor.primaryColor,
          centerTitle: true,
          title: const Text("OVo do breno"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    openDialog();
                  });
                  //Navigator.push(
                  //context,
                  //MaterialPageRoute(builder: (context) => openDialog()),
                  //);
                },
                icon: const Icon(Icons.plus_one_outlined))
          ],
        ),
        body: showOsTable());
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
                      //backgroundColor: Colors.red,
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
                        child: TextFormField(
                          controller: newOSController,
                          style: const TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Enter os Name",
                            //hintStyle: TextStyle(color: Color.fromARGB(a, r, g, b)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            print(value);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: const Text("Create OS"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            newOSController.clear();
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
