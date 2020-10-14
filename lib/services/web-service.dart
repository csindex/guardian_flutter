import '../data/data.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Webservice {

  Future<List<Data>> fetchNotifications(String keyword) async {

    final url = "https://dep.guardian4emergency.com/api/getNotifications?keyword=" + keyword;
    final response = await http.get(url);
    if(response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body["data"];
      return json.map((data) => Data.fromJsonMap(data)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

}