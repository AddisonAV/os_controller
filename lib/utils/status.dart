import 'package:http/http.dart' as http;
import 'package:os_controller/utils/StatusChangeNotifier.dart';
import 'package:os_controller/utils/dataLoadEvent.dart';
import 'dart:convert';
import 'package:os_controller/utils/providers.dart';
import 'package:event_bus/event_bus.dart';

class Status {
  List dataStatus = [];
  List<String> statusList = [];
  Map<String, String> statusID = {};

  late DataLoadEvent dataLoadEvent;

  String? findStatusID(String status) {
    return statusID[status];
  }

  bool addStatus(String status) {
    print(statusList);
    if (!statusList.contains(status)) {
      statusList.add(status);
      statusID[status] = statusList.length.toString();
      dataStatus.add({
        "id": statusList.length.toString(),
        "status": status,
      });
      getIt<EventBus>().fire(DataLoadEvent(true));
      taskUpdater.updateTaskMap();
      //ADICIONAR OS METODOS HTTP PARA ADICIONAR UM NOVO STATUS
      return true;
    }

    return false;
  }

  String findStatus(String ID) {
    String result = '';
    statusID.forEach((key, value) {
      if (value == ID) {
        result = key;
      }
    });
    return result;
  }

  Future getAllStatus() async {
    final response = await http.get(Uri.parse('http://localhost:9898/status'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      dataStatus = jsonData;
      dataLoadEvent = DataLoadEvent(true);

      for (var aux in dataStatus) {
        statusList.add(aux['status']);
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
