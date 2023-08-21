import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:siraf3/db/model/search_history.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/screens/filter_screen.dart';
import 'package:siraf3/screens/search_result_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/text_field_2.dart';

import '../helpers.dart';

class SearchScreen extends StatefulWidget {
  FilterData originalFilterData;
  FilterData filterData;

  SearchScreen({required this.originalFilterData, required this.filterData});

  @override
  State<StatefulWidget> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  late TextEditingController searchController;

  List<SearchHistory> keywords = [];

  Future<void> fillKeywords() async {
    var keywords = await SearchHistory.all();
    setState(() {
      this.keywords = keywords;
    });
  }

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();

    setKeywords();
  }

  setKeywords() {
    fillKeywords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: MyBackButton(),
        title: TextField2(
          controller: searchController,
          onSubmitted: (searchedText) {
            onSubmittedSearchField(searchedText);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "جستجو فایل",
            hintStyle: TextStyle(
              fontSize: 14,
              color: App.theme.tooltipTheme.textStyle?.color,
            ),
          ),
          textInputAction: TextInputAction.search,
          style: TextStyle(
            fontSize: 14,
            color: App.theme.textTheme.bodyLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FilterScreen(
                    originalFilterData: widget.originalFilterData,
                    filterData: widget.filterData,
                    total_url: getFileUrl('file/files/').toString(),
                  ),
                ),
              );

              if (result != null && result is FilterData) {
                setState(() {
                  widget.filterData = result;
                });

                print(widget.filterData.toQueryString());
              }
            },
            icon: badges.Badge(
              badgeContent: Text(''),
              showBadge: widget.filterData.hasFilter(),
              position: badges.BadgePosition.custom(top: -15, start: -10),
              badgeStyle: badges.BadgeStyle(badgeColor: Themes.primary),
              child: icon(
                OctIcons.sliders_16,
                size: 20,
              ),
            ),
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
                padding: EdgeInsets.only(left: 5, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(
                    //   "سابقه جستجو",
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: Themes.blue,
                    //     fontFamily: "IranSansBold",
                    //   ),
                    // ),
                    TextButton(
                      onPressed: () {
                        emptyHistory();
                      },
                      child: Text(
                        "پاک کردن سوابق",
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
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 0, bottom: 10, right: 20),
        child: Expanded(
          child: GestureDetector(
            onTap: () {
              searchController.text = searchHistory.keyword;

              onSubmittedSearchField(searchController.text);
            },
            child: Text(
              searchHistory.keyword,
              style: TextStyle(
                fontSize: 13,
                // color: Themes.textGrey,
              ),
            ),
          ),
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

    setState(() {
      widget.filterData.search = searchedText;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultScreen(
          originalFilterData: widget.originalFilterData,
          filterData: widget.filterData,
        ),
      ),
    );
  }

  void emptyHistory() {
    SearchHistory.truncate().then((_) {
      fillKeywords();
      setState(() {});
    });
  }
}
