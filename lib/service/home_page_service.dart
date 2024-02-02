import 'dart:convert';

import 'package:api_task/model/api_model.dart';
import 'package:http/http.dart' as http;

class HomePageService {
  static HomePageService? _instance;

  HomePageService._internal();

  static HomePageService getInstance() {
    _instance ??= HomePageService._internal();
    return _instance!;
  }

  static const String baseUrl = 'https://reqres.in/api/users?page=';

  Future<List<HomeApiModelData>> getApiData(int pageNo) async {
    try {
      var response = await http.get(Uri.parse("$baseUrl$pageNo"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        HomeApiModel homeApiModel = HomeApiModel.fromJson(jsonResponse);
        return homeApiModel.data ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Error:::$e");
      return [];
    }
  }
}
