import 'package:api_task/provider/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageProvider homePageProvider = HomePageProvider();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double pixelsRemaining = _scrollController.position.extentAfter;

      if (pixelsRemaining < 500) {
        homePageProvider.loadMoreData();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<HomePageProvider>(
      create: (context) {
        return HomePageProvider()..getApiRes();
      },
      child: Consumer<HomePageProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Home"),
                centerTitle: true,
                elevation: 1,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: provider.searchController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none, hintText: "Search"),
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  provider.searchDataList.clear();
                                } else {
                                  provider.searchDataList =
                                      provider.searchName(value.trim());
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      provider.isLoading
                          ? const CircularProgressIndicator()
                          : provider.searchController.text.trim().isNotEmpty &&
                                  provider.searchDataList.isEmpty
                              ? const Text("No Data  found")
                              : provider.searchController.text
                                          .trim()
                                          .isNotEmpty &&
                                      provider.searchDataList.isNotEmpty
                                  ? ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var item =
                                            provider.searchDataList[index];
                                        return Card(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                                radius: 30,
                                                backgroundImage:
                                                    NetworkImage(item.avatar!)),
                                            title: Text(item.firstName!),
                                            subtitle: Text(item.email!),
                                          ),
                                        ));
                                      },
                                      itemCount: provider.searchDataList.length)
                                  : ListView.builder(
                                      controller: _scrollController,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var item = provider.apiDataList[index];
                                        return Card(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                                radius: 30,
                                                backgroundImage:
                                                    NetworkImage(item.avatar!)),
                                            title: Text(item.firstName!),
                                            subtitle: Text(item.email!),
                                          ),
                                        ));
                                      },
                                      itemCount: provider.apiDataList.length)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
