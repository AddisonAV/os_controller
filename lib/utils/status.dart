import 'package:http/http.dart' as http;
import 'package:os_controller/utils/dataLoadEvent.dart';
import 'dart:convert';
import 'package:os_controller/utils/providers.dart';
import 'package:event_bus/event_bus.dart';

class Status {
  List dataStatus = [];
  List<String> StatusList = [];
  Map<String, String> statusID = {};

  late DataLoadEvent dataLoadEvent;

  Status() {
    getAllStatus();
  }

  String? findStatusID(String status) {
    return statusID[status];
  }

  Future getAllStatus() async {
    final response = await http.get(Uri.parse('http://localhost:9898/status'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      dataStatus = jsonData;
      dataLoadEvent = DataLoadEvent(true);

      for (var aux in dataStatus) {
        StatusList.add(aux['status']);
        statusID.addAll({aux['status']: aux['id'].toString()});
      }
    } else {
      dataLoadEvent = DataLoadEvent(false);
      throw Exception('Failed to load status');
    }
    getIt<EventBus>().fire(dataLoadEvent);
    return "sucess";
  }
}

Status status = Status();
