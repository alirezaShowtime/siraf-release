import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/bookmark_item.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookmarkScreen();
}

class _BookmarkScreen extends State<BookmarkScreen> {
  List<File> selectedFiles = [];

  bool isSelectable = false;

  //todo: file variable is temporary variable
  File file = File(
    name: "فایل شماره دو",
    city: "تهران",
    id: 1,
    description: "this is a test file, os don`t see it",
    favorite: false,
    publishedAgo: "این هفته",
    fullCategory: FullCategory(
      name: "مسکونی",
      id: 1,
      image:
          "https://www.ers.ga.gov/sites/main/files/imagecache/carousel/main-images/camera_lense_0.jpeg",
    ),
    propertys: [
      Property(
        name: "آسانسور",
        value: "0",
        weightList: 1,
      ),
      Property(
        name: "اتاق",
        value: "3",
        weightList: 2,
      ),
      Property(
        name: "پارکینگ",
        value: "1",
        weightList: 3,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.background,
      appBar: AppBar(
        backgroundColor: Themes.appBar,
        title: AppBarTitle("نشانها و یادداشت ها"),
        automaticallyImplyLeading: false,
        elevation: 0.7,
        leading: MyBackButton(),
        actions: [
          IconButton(
            onPressed: onClickCompareButton,
            disabledColor: Colors.grey,
            icon: icon(Icons.compare_rounded),
            tooltip: "مقایسه فایل ها",
          ),
          MyPopupMenu(
            icon: icon(Icons.sort_rounded),
            items: [
              PopupMenuItem(
                onTap: sortByOnlyFile,
                child: Text(
                  "فقط فایل ها",
                  style: TextStyle(fontSize: 13),
                ),
              ),
              PopupMenuItem(
                onTap: sortByOnlyContent,
                child: Text(
                  "فقط محتوا",
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          MyPopupMenu(
            icon: icon(Icons.more_vert_rounded),
            items: [
              PopupMenuItem(
                onTap: deleteAllSelected,
                child: Text(
                  "حذف انتخاب شده ها",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        //here is one more item added for make padding top in listview
        itemCount: 10 + 1,
        itemBuilder: (BuildContext context, int i) {
          if (i == 0) return SizedBox(height: 10);
          //todo: MyFileHorizontalItem widget don`t use in this place,must be create another widget and replace it
          return BookmarkItem(
            file: file,
            isSelectable: true,
            isSelected: selectedFiles.contains(file),
            onChanged: (value) {
              setState(
                () {
                  if (value) {
                    selectedFiles.add(file);
                  } else {
                    selectedFiles.remove(file);
                  }
                  if (selectedFiles.isEmpty) {
                    isSelectable = false;
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  //event listeners

  void deleteAllSelected() {
    //todo: implement event listener
  }

  void onClickCompareButton() {
    //todo: implement event listener

    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => CompareScreen(files: selectedFiles)));
  }

  void sortByOnlyFile() {
    //todo: implement event listener
  }

  void sortByOnlyContent() {
    //todo: implement event listener
  }
}
