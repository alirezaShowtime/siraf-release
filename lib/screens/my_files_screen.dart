import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/delete_file_bloc.dart';
import 'package:siraf3/bloc/my_files_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/my_file.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/create/create_file_first.dart';
import 'package:siraf3/screens/my_file_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_file_horizontal_item.dart';
import 'package:siraf3/widgets/try_again.dart';

class MyFilesScreen extends StatefulWidget {
  const MyFilesScreen({super.key});

  @override
  State<MyFilesScreen> createState() => _MyFilesScreenState();
}

class _MyFilesScreenState extends State<MyFilesScreen> {
  bool canDelete = false;
  bool isSelectable = false;
  List<MyFile> selectedFiles = [];
  List<MyFile> files = [];
  String? currentSortType = null;

  MyFilesBloc bloc = MyFilesBloc();

  DeleteFileBloc deleteFileBloc = DeleteFileBloc();

  @override
  void initState() {
    super.initState();

    _loadFiles();

    bloc.stream.listen((event) {
      if (event is MyFilesLoadedState) {
        setState(() {
          currentSortType = event.sort;
        });
      }
    });

    deleteFileBloc.stream.listen((event) {
      if (event is DeleteFileLoadingState) {
        showLoadingDialog(message: "در حال حذف فایل ها هستیم لطفا شکیبا باشید");
      } else if (event is DeleteFileErrorState) {
        dissmisLoadingDialog();
        notify("خطا در حذف فایل ها رخ داد لطفا مجدد تلاش کنید");
      } else if (event is DeleteFileSuccessState) {
        dissmisLoadingDialog();
        dismissDeleteDialog();

        notify("حذف فایل ها با موفقیت انجام شد");

        _loadFiles();
      }
    });
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
          appBar: AppBar(
            backgroundColor: Themes.background,
            title: Text(
              "فایل های من",
              style: TextStyle(
                fontSize: 15,
                color: Themes.text,
              ),
            ),
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                if (isSelectable) {
                  setState(() {
                    isSelectable = false;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                CupertinoIcons.back,
                color: Themes.icon,
              ),
            ),
            elevation: 0.7,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CreateFileFirst()));
                },
                icon: Icon(
                  CupertinoIcons.add,
                  color: Themes.icon,
                ),
              ),
              IconButton(
                onPressed: selectedFiles.isNotEmpty
                    ? () {
                        showDeleteDialog(
                            selectedFiles.map((e) => e.id!).toList());
                      }
                    : null,
                icon: Icon(
                  CupertinoIcons.delete,
                  color:
                      selectedFiles.isNotEmpty ? Themes.icon : Themes.iconGrey,
                ),
                disabledColor: Themes.iconGrey,
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<String>(
                      value: "",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "جدید ترین",
                            style: TextStyle(
                              fontSize: 13,
                              color: Themes.text,
                            ),
                          ),
                          if (currentSortType == "" || currentSortType == null)
                            Icon(
                              Icons.check,
                              color: Themes.icon,
                              size: 20,
                            ),
                        ],
                      ),
                      height: 35,
                    ),
                    PopupMenuItem<String>(
                      value: "8",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "قدیمی ترین",
                            style: TextStyle(
                              fontSize: 13,
                              color: Themes.text,
                            ),
                          ),
                          if (currentSortType == "8")
                            Icon(
                              Icons.check,
                              color: Themes.icon,
                              size: 20,
                            ),
                        ],
                      ),
                      height: 35,
                    ),
                    PopupMenuItem<String>(
                      value: "1",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "در انتظار تایید",
                            style: TextStyle(
                              fontSize: 13,
                              color: Themes.text,
                            ),
                          ),
                          if (currentSortType == "1")
                            Icon(
                              Icons.check,
                              color: Themes.icon,
                              size: 20,
                            ),
                        ],
                      ),
                      height: 35,
                    ),
                    PopupMenuItem<String>(
                      value: "5",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "در انتظار پذیرش",
                            style: TextStyle(
                              fontSize: 13,
                              color: Themes.text,
                            ),
                          ),
                          if (currentSortType == "5")
                            Icon(
                              Icons.check,
                              color: Themes.icon,
                              size: 20,
                            ),
                        ],
                      ),
                      height: 35,
                    ),
                    PopupMenuItem<String>(
                      value: "7",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "پذیرش شده",
                            style: TextStyle(
                              fontSize: 13,
                              color: Themes.text,
                            ),
                          ),
                          if (currentSortType == "7")
                            Icon(
                              Icons.check,
                              color: Themes.icon,
                              size: 20,
                            ),
                        ],
                      ),
                      height: 35,
                    ),
                    PopupMenuItem<String>(
                      value: "3",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "رد شده",
                            style: TextStyle(
                              fontSize: 13,
                              color: Themes.text,
                            ),
                          ),
                          if (currentSortType == "3")
                            Icon(
                              Icons.check,
                              color: Themes.icon,
                              size: 20,
                            ),
                        ],
                      ),
                      height: 35,
                    ),
                  ];
                },
                onSelected: (String value) {
                  _loadFiles(sort: value);
                },
                icon: Icon(
                  CupertinoIcons.sort_down,
                  color: Themes.icon,
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
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
                  ];
                },
                onSelected: (value) {
                  setState(() {
                    selectedFiles.clear();
                    selectedFiles.addAll(files);
                    isSelectable = true;
                  });
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Themes.icon,
                ),
              ),
            ],
          ),
          body: BlocBuilder<MyFilesBloc, MyFilesState>(
            builder: _buildMainBloc,
          ),
        ),
      ),
    );
  }

  Widget _buildMainBloc(BuildContext context, MyFilesState state) {
    if (state is MyFilesLoadingState || state is MyFilesInitState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is MyFilesErrorState) {
      print(state.response!.body);
      
      return Center(
        child: TryAgain(
          onPressed: _loadFiles,
          message: state.response != null
              ? jDecode(state.response!.body)['message']
              : "خطا در دریافت اطلاعات پیش آمد مجدد تلاش کنید",
        ),
      );
    }

    state = state as MyFilesLoadedState;

    files = state.files;

    return ListView(
      children: state.files
          .map<Widget>((file) => GestureDetector(
                onTap: () async {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyFileScreen(
                        id: file.id!,
                        progress: file.progress!,
                      ),
                    ),
                  );

                  if (result is String && result == "refresh") {
                    _loadFiles();
                  }
                },
                onLongPress: () {
                  setState(() {
                    isSelectable = true;

                    if (!selectedFiles.contains(file)) {
                      selectedFiles.add(file);
                    } else {
                      selectedFiles.remove(file);
                    }

                    if (selectedFiles.isEmpty) {
                      isSelectable = false;
                    }
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      top: (state as MyFilesLoadedState).files.first == file
                          ? 0
                          : 5),
                  child: MyFileHorizontalItem(
                    file: file,
                    isSelectable: isSelectable,
                    isSelected: selectedFiles.contains(file),
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          selectedFiles.add(file);
                        } else {
                          selectedFiles.remove(file);
                        }
                        if (selectedFiles.isEmpty) {
                          isSelectable = false;
                        }
                      });
                    },
                  ),
                ),
              ))
          .toList(),
    );
  }

  void _loadFiles({String? sort}) {
    bloc.add(MyFilesEvent(sort: sort));
    setState(() {
      selectedFiles.clear();
    });
  }

  showLoadingDialog({String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        loadingDContext = _;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    message ?? 'در حال ارسال درخواست صبور باشید',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Loading(),
              ],
            ),
          ),
        );
      },
    );
  }

  dissmisLoadingDialog() {
    if (loadingDContext != null) {
      Navigator.pop(loadingDContext!);
    }
  }

  BuildContext? loadingDContext;

  BuildContext? deleteDialogContext;

  showDeleteDialog(List<int> ids) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        deleteDialogContext = _;
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Themes.background,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Wrap(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Text(
                        'آیا مایل به حذف فایل هستید؟',
                        style: TextStyle(
                          color: Themes.textGrey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: dismissDeleteDialog,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "خیر",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: "IranSansBold",
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 9),
                            ),
                          ),
                          SizedBox(
                            width: 0.5,
                          ),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () async {
                                deleteFileBloc.add(
                                  DeleteFileListEvent(
                                    ids: ids,
                                    token: await User.getBearerToken(),
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "بله",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: "IranSansBold",
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  dismissDeleteDialog() {
    if (deleteDialogContext != null) {
      Navigator.pop(deleteDialogContext!);
    }
  }
}
