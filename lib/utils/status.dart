import 'package:http/http.dart' as http;
import 'dart:convert';

class Status {
  List dataStatus = [];

  Status() {
    getAllStatus();
  }

  Future getAllStatus() async {
    final response = await http.get(Uri.parse('http://localhost:9898/status'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      dataStatus = jsonData;
    } else {
      throw Exception('Failed to load status');
    }
    return "sucess";
  }
}

Status status = Status();
