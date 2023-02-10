import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/bookmark_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/favorite_file.dart';
import 'package:siraf3/models/file.dart' as file;
import 'package:siraf3/screens/compare_screen.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/bookmark_file_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/try_again.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookmarkScreen();
}

class _BookmarkScreen extends State<BookmarkScreen> {
  bool isSelectable = false;

  List<FavoriteFile> selectedFiles = [];

  BookmarkBloc bloc = BookmarkBloc();

  List<FavoriteFile> files = [];

  @override
  void initState() {
    super.initState();

    getFiles();
  }

  int? sort;

  getFiles() {
    bloc.add(BookmarkEvent(sort: sort));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: WillPopScope(
        onWillPop: () async {
          if (isSelectable) {
            setState(() {
              isSelectable = false;
            });
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Themes.background,
          appBar: AppBar(
            backgroundColor: Themes.appBar,
            title: AppBarTitle(
              "نشانها و یادداشت ها",
              fontSize: 15,
            ),
            automaticallyImplyLeading: false,
            elevation: 0.7,
            leading: MyBackButton(
              onPressed: () {
                if (isSelectable) {
                  setState(() {
                    isSelectable = false;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            titleSpacing: 0,
            actions: [
              InkWell(
                onTap: _compare,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                  child: Text(
                    "مقایسه",
                    style: TextStyle(
                      fontSize: 13,
                      color: Themes.text,
                    ),
                  ),
                ),
              ),
              MyPopupMenuButton(
                itemBuilder: (_) => <PopupMenuItem<int?>>[
                  PopupMenuItem<int?>(
                    value: null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "نمایش همه",
                          style: TextStyle(
                            fontSize: 13,
                            color: Themes.text,
                          ),
                        ),
                        if (sort == null)
                          Icon(
                            Icons.check,
                            color: Themes.icon,
                            size: 20,
                          ),
                      ],
                    ),
                    height: 35,
                  ),
                  PopupMenuItem<int?>(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "فقط فایل ها",
                          style: TextStyle(
                            fontSize: 13,
                            color: Themes.text,
                          ),
                        ),
                        if (sort == 1)
                          Icon(
                            Icons.check,
                            color: Themes.icon,
                            size: 20,
                          ),
                      ],
                    ),
                    height: 35,
                  ),
                  PopupMenuItem<int?>(
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "فقط محتوا ها",
                          style: TextStyle(
                            fontSize: 13,
                            color: Themes.text,
                          ),
                        ),
                        if (sort == 2)
                          Icon(
                            Icons.check,
                            color: Themes.icon,
                            size: 20,
                          ),
                      ],
                    ),
                    height: 35,
                  ),
                ],
                icon: icon(Icons.sort_rounded),
                onSelected: (val) {
                  setState(() {
                    sort = val;
                  });
                  getFiles();
                },
              ),
              MyPopupMenuButton(
                itemBuilder: (_) => <PopupMenuItem>[
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "انتخاب همه",
                      style: TextStyle(
                        fontSize: 13,
                        color: Themes.text,
                      ),
                    ),
                    height: 35,
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(
                      "حذف",
                      style: TextStyle(
                        fontSize: 13,
                        color: Themes.text,
                      ),
                    ),
                    height: 35,
                  ),
                ],
                icon: icon(Icons.more_vert_rounded),
                onSelected: (val) {
                  if (val == 0) {
                    setState(() {
                      isSelectable = true;
                      selectedFiles = files;
                    });
                  } else if (val == 1) {
                    //todo delete all selected
                  }
                },
              ),
            ],
          ),
          body: BlocBuilder<BookmarkBloc, BookmarkState>(builder: _builder),
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, BookmarkState state) {
    if (state is BookmarkInitState) {
      return Container();
    }
    if (state is BookmarkLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is BookmarkErrorState) {
      String? message = jDecode(state.response.body)['message'] ?? null;
      return Center(
        child: TryAgain(
          message: message,
          onPressed: getFiles,
        ),
      );
    }

    state = state as BookmarkLoadedState;

    files = state.data;

    return ListView(
      children: files.map<Widget>(
        (e) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FileScreen(
                    id: e.fileId!.id!,
                  ),
                ),
              );
            },
            onLongPress: () {
              setState(() {
                isSelectable = true;

                if (!selectedFiles.contains(e)) {
                  selectedFiles.add(e);
                } else {
                  selectedFiles.remove(e);
                }

                if (selectedFiles.isEmpty) {
                  isSelectable = false;
                }
              });
            },
            child: BookmarkFileItem(
              file: e,
              isSelectable: isSelectable,
              isSelected: selectedFiles.contains(e),
              onChanged: (value) {
                setState(() {
                  if (value) {
                    selectedFiles.add(e);
                  } else {
                    selectedFiles.remove(e);
                  }
                  if (selectedFiles.isEmpty) {
                    isSelectable = false;
                  }
                });
              },
              onRemoveFavorite: (file) {
                setState(() {
                  files.remove(e);
                });
              },
            ),
          );
        },
      ).toList(),
    );
  }

  void _compare() {
    if (selectedFiles.length < 2) {
      return notify(
          "جهت مقایسه حداقل می بایست دو فایل هم نوع را انتخاب نمایید");
    }

    int? parentId;

    selectedFiles.forEach((element) {
      if (parentId == null) {
        parentId = element.fileId!.category!.parentId;
      }
      if (parentId != element.fileId!.category!.parentId) {
        return notify("فایل های انتخابی شما هم نوع نمی باشند");
      }
    });

    List<file.File> files = selectedFiles.map<file.File>((e) {
      return file.File(
        id: e.fileId!.id,
        city: e.fileId!.city,
        // description: e.fileId!.description,
        favorite: true,
        fullCategory: null,
        name: e.fileId!.name,
        images: e.fileId!.images
                ?.map<file.Images>((e) => file.Images.fromJson(e.toJson()))
                .toList() ??
            [],
        propertys: e.fileId!.propertys
                ?.map<file.Property>((e) => file.Property.fromJson(e.toJson()))
                .toList() ??
            [],
        publishedAgo: e.fileId!.publishedAgo,
      );
    }).toList();

    files.forEach((element) {
      print(element.toJson());
    });

    Navigator.push(context,
        MaterialPageRoute(builder: (_) => CompareScreen(files: files)));
  }
}
