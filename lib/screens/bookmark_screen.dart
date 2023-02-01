import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/my_back_button.dart';

import '../models/my_file.dart';
import '../widgets/my_file_horizontal_item.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookmarkScreen();
}

class _BookmarkScreen extends State<BookmarkScreen> {
  List<MyFile> selectedFiles = [];

  bool isSelectable = false;

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
          IconButton(onPressed: () {}, icon: icon(Icons.compare_rounded)),
          IconButton(onPressed: () {}, icon: icon(Icons.sort_rounded)),
          IconButton(onPressed: () {}, icon: icon(Icons.more_vert_rounded)),
        ],
      ),
      body: ListView.builder(
        //here is one more item added for make padding top in listview
        itemCount: 10 + 1,
        itemBuilder: (BuildContext context, int i) {
          MyFile file = MyFile(
            name: "فایل شماره دو",
            city: "تهران",
            id: 1,
            description: "this is a test file, os don`t see it",
            favorite: false,
            publishedAgo: "این هفته",
            category: Category(
              name: "مسکونی",
              id: 1,
              image:
                  "https://www.ers.ga.gov/sites/main/files/imagecache/carousel/main-images/camera_lense_0.jpeg",
            ),
          );
          if (i == 0) return SizedBox(height: 10);
          //todo: MyFileHorizontalItem widget don`t use in this place,must be create another widget and replace it
          return MyFileHorizontalItem(
            file: MyFile(
              name: "فایل شماره دو",
              city: "تهران",
              id: 1,
              description: "this is a test file, os don`t see it",
              favorite: false,
              publishedAgo: "این هفته",
              category: Category(
                name: "مسکونی",
                id: 1,
                image:
                    "https://www.ers.ga.gov/sites/main/files/imagecache/carousel/main-images/camera_lense_0.jpeg",
              ),
              propertys: [
                Propertys(
                  name: "آسانسور",
                  value: 0,
                  weightList: 1,
                ),
                Propertys(
                  name: "اتاق",
                  value: 3,
                  weightList: 2,
                ),
                Propertys(
                  name: "پارکینگ",
                  value: 1,
                  weightList: 3,
                ),
              ],
            ),
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
}
