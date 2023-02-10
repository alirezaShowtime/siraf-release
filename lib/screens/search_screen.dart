import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:siraf3/db/model/search_history.dart';
import 'package:siraf3/screens/filter_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/text_field_2.dart';

import '../helpers.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  late TextEditingController searchController;

  List<SearchHistory> keywords = [];

  Future<void> fillKeywords() async {
    keywords = await SearchHistory.all();
  }

  @override
  void initState() {
    super.initState();

    fillKeywords();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.background,
      appBar: AppBar(
        backgroundColor: Themes.appBar,
        titleSpacing: 0,
        elevation: 0.7,
        automaticallyImplyLeading: false,
        leading: MyBackButton(),
        title: TextField2(
          controller: searchController,
          onSubmitted: (searchedText) {
            onSubmittedSearchField(searchedText);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "جستوجو فایل",
            hintStyle: TextStyle(
              fontSize: 14,
            ),
          ),
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              navigateTo(context, FilterScreen());
            },
            icon: icon(OctIcons.sliders_16, size: 20),
          ),
          IconButton(
            onPressed: () {
              onSubmittedSearchField(searchController.text);
            },
            icon: icon(CupertinoIcons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Visibility(
              visible: keywords.length > 0,
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "سابقه جستوجو",
                      style: TextStyle(
                          fontSize: 12,
                          color: Themes.blue,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        emptyHistory();
                      },
                      child: Text(
                        "پاک کردن",
                        style: TextStyle(
                          fontSize: 12,
                          color: Themes.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: ListView.builder(
              itemCount: keywords.length,
              itemBuilder: (BuildContext context, int i) {
                return historyItem(keywords[i]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget historyItem(SearchHistory searchHistory) {
    return InkWell(
      onTap: () {
        searchController.text = searchHistory.keyword;
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: icon(Icons.history_rounded),
            ),
            Expanded(
              child: Text(
                searchHistory.keyword,
                style: TextStyle(
                  fontSize: 13,
                  color: Themes.textGrey,
                ),
              ),
            ),
            icon(CupertinoIcons.arrow_up_left),
          ],
        ),
      ),
    );
  }

  void onSubmittedSearchField(String searchedText) {
    //todo: if exist result with keyword in serve, store on database and navigate to result page

    if (searchedText.isEmpty) return;
    SearchHistory.createIfNotExist(searchedText).then((_) {
      fillKeywords();
      setState(() {});
    });
  }

  void emptyHistory() {
    SearchHistory.truncate().then((_) {
      fillKeywords();
      setState(() {});
    });
  }
}
