import 'package:api_task/model/api_model.dart';
import 'package:api_task/service/home_page_service.dart';
import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  List<HomeApiModelData> apiDataList = [];
  List<HomeApiModelData> searchDataList = [];

  int _pageNo = 1;

  int get pageNo => _pageNo;

  set pageNo(int value) {
    _pageNo = value;
    notifyListeners();
  }

  getApiRes() async {
    isLoading = true;
    notifyListeners();
    List<HomeApiModelData> newData =
    await HomePageService.getInstance().getApiData(_pageNo);
    apiDataList.addAll(newData);
    isLoading = false;
    notifyListeners();
  }

  searchName(values) {
    values = values.toLowerCase();
    return apiDataList.where((element) {
      final name = element.firstName!.toLowerCase();
      return name.contains(values);
    }).toList();
  }

  Future<void> loadMoreData() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();

      List<HomeApiModelData> newData =
      await HomePageService.getInstance().getApiData(pageNo + 1);
      if (newData.isNotEmpty) {
        apiDataList.addAll(newData);
        pageNo = pageNo + 1;
      }

      isLoading = false;
      notifyListeners();
    }
  }}
