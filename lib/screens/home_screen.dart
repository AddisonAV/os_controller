import 'package:flutter/material.dart';
import 'package:os_controller/screens/create_os.dart';
import 'package:os_controller/ui/colors.dart';
import 'package:os_controller/utils/service_order.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget ShowOsTable() {
    return Column(
      children: const [ServiceOrder(), ServiceOrder()],
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
          title: const Text("Meu ovo"),
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
        body: ShowOsTable());
  }
}
