import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/bookmark_bloc.dart';
import 'package:siraf3/bloc/notes_bloc.dart';
import 'package:siraf3/bookmark.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/favorite_file.dart';
import 'package:siraf3/models/file.dart' as file;
import 'package:siraf3/models/note.dart';
import 'package:siraf3/screens/compare_screen.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/bookmark_file_item.dart';
import 'package:siraf3/widgets/empty.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/note_file_item.dart';
import 'package:siraf3/widgets/try_again.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookmarkScreen();
}

class _BookmarkScreen extends State<BookmarkScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<BookmarkScreen> {
  @override
  bool get wantKeepAlive => true;

  bool isSelectable = false;

  List<FavoriteFile> selectedFiles = [];

  BookmarkBloc bloc = BookmarkBloc();
  NotesBloc notesBloc = NotesBloc();

  List<FavoriteFile> files = [];
  List<Note> notes = [];

  late TabController tabController;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();

    tabController = new TabController(vsync: this, length: 2);

    tabController.addListener(() {
      setState(() {
        currentTabIndex = tabController.index;
      });
    });

    getFiles();
    getNotes();
  }

  @override
  void dispose() {
    super.dispose();

    bloc.close();
  }

  int? sort;

  getFiles() {
    bloc.add(BookmarkEvent(sort: sort));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => bloc,
        ),
        BlocProvider(
          create: (_) => notesBloc,
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (isSelectable) {
            setState(() {
              selectedFiles.clear();
              isSelectable = false;
            });
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
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
                    selectedFiles.clear();
                    isSelectable = false;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            bottom: TabBar(
              controller: tabController,
              dividerColor: Themes.textGrey.withOpacity(0.5),
              // todo : temporaray
              labelColor: Themes.text,
              unselectedLabelColor: Themes.textGrey,
              labelStyle: TextStyle(
                fontSize: 14,
                fontFamily: "IranSansBold",
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontFamily: "IranSansBold",
              ),
              indicatorColor: Themes.primary,
              tabs: [
                Tab(text: "نشان ها"),
                Tab(text: "یادداشت ها"),
              ],
            ),
            titleSpacing: 0,
            actions: [
              if (currentTabIndex == 0 && files.length > 1)
                InkWell(
                  onTap: _compare,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                    child: Text(
                      "مقایسه",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              if (currentTabIndex == 0)
                MyPopupMenuButton(
                  itemBuilder: (_) => <PopupMenuItem>[
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text(
                        "انتخاب همه",
                        style: TextStyle(
                          fontSize: 13,
                          color: App.theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      height: 35,
                    ),
                    if (selectedFiles.isNotEmpty)
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text(
                          "حذف",
                          style: TextStyle(
                            fontSize: 13,
                            color: App.theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        height: 35,
                      ),
                  ],
                  iconData: Icons.more_vert_rounded,
                  onSelected: (val) async {
                    if (val == 0) {
                      setState(() {
                        isSelectable = true;

                        selectedFiles.clear();
                        files.forEach((element) {
                          selectedFiles.add(element);
                        });
                      });
                    }
                    if (val == 1) {
                      var result = await Bookmark.removeFavoriteList(context: context, ids: selectedFiles.map((e) => e.fileId!.id!).toList());
                      if (result) {
                        setState(() {
                          files.removeWhere((file) => selectedFiles.any((e) => e.id == file.id));
                          selectedFiles.clear();
                          isSelectable = false;
                        });
                      }
                    }
                  },
                ),
            ],
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              BlocBuilder<BookmarkBloc, BookmarkState>(builder: _fileBuilder),
              BlocBuilder<NotesBloc, NotesState>(builder: _noteBuilder),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fileBuilder(BuildContext context, BookmarkState state) {
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

    if (files.isEmpty) {
      return Center(
        child: Empty(
          message: "موردی نشان نشده است",
        ),
      );
    }

    return ListView(
      children: files.map<Widget>(
        (e) {
          return GestureDetector(
            onTap: isSelectable ? () => changeSelection(e) : () => onTapFile(e.fileId!.id!),
            onLongPress: () => changeSelection(e),
            child: BookmarkFileItem(
              file: e,
              isSelected: selectedFiles.contains(e),
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

  void _compare() async {
    if (selectedFiles.length < 2) {
      return notify("جهت مقایسه حداقل می بایست دو فایل هم نوع را انتخاب نمایید");
    }

    int? parentId;

    for (var element in selectedFiles) {
      if (parentId == null) {
        parentId = element.fileId!.category!.parentId;
      }
      if (parentId != element.fileId!.category!.parentId) {
        return notify("فایل های انتخابی شما هم نوع نمی باشند");
      }
    }

    List<file.File> files = selectedFiles.map<file.File>((e) {
      return file.File(
        id: e.fileId!.id,
        city: file.City(name: e.fileId!.city),
        // description: e.fileId!.description,
        favorite: true,
        fullCategory: null,
        name: e.fileId!.name,
        images: e.fileId!.images?.map<file.Images>((e) => file.Images.fromJson(e.toJson())).toList() ?? [],
        propertys: e.fileId!.propertys?.map<file.Property>((e) => file.Property.fromJson(e.toJson())).toList() ?? [],
        publishedAgo: e.fileId!.publishedAgo,
      );
    }).toList();

    files.forEach((element) {
      print(element.toJson());
    });

    await Navigator.push(context, MaterialPageRoute(builder: (_) => CompareScreen(files: files)));

    setState(() {
      selectedFiles.clear();
      isSelectable = false;
    });
  }

  changeSelection(FavoriteFile e) {
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
  }

  onTapFile(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FileScreen(
          id: id,
        ),
      ),
    );
  }

  Widget _noteBuilder(BuildContext context, NotesState state) {
    if (state is NotesInitState) {
      return Container();
    }
    if (state is NotesLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is NotesErrorState) {
      String? message = jDecode(state.response.body)['message'] ?? null;
      return Center(
        child: TryAgain(
          message: message,
          onPressed: getFiles,
        ),
      );
    }

    state = state as NotesLoadedState;

    notes = state.notes;

    if (notes.isEmpty) {
      return Center(
        child: Empty(
          message: "یادداشتی ثبت نشده است",
        ),
      );
    }

    return ListView(
      children: notes.map<Widget>(
        (e) {
          return GestureDetector(
            onTap: () => onTapFile(e.fileId!.id!),
            child: NoteFileItem(
              note: e,
              isSelected: false,
              onRemoveFavorite: (file) {
                setState(() {
                  notes.remove(e);
                });
              },
            ),
          );
        },
      ).toList(),
    );
  }

  void getNotes() {
    notesBloc.add(NotesEvent());
  }
}
