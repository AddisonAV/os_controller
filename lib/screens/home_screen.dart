import 'package:flutter/material.dart';
import 'package:os_tracker/ui/colors.dart';
import 'package:os_tracker/utils/service_order.dart';

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
          title: const Text("If u read this u corno man!"),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
          ],
        ),
        body: ShowOsTable());
  }
}
