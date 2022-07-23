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
  Widget showOsTable() {
    return Column(
      children: const [TaskWidget(), TaskWidget()],
    );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateOSForm()),
                  );
                },
                icon: const Icon(Icons.plus_one_outlined))
          ],
        ),
        body: showOsTable());
  }
}
