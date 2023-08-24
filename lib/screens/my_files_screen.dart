import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/delete_file_bloc.dart';
import 'package:siraf3/bloc/my_files_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/my_file.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/create/create_file_first.dart';
import 'package:siraf3/screens/my_file_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_file_horizontal_item.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
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
  void dispose() {
    super.dispose();

    bloc.close();

    deleteFileBloc.close();
  }

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
        loadingDialog(context: context, showMessage: false);
      } else if (event is DeleteFileErrorState) {
        dismissDeleteDialog();
        dismissDialog(loadingDialogContext);
        errorDialog(context: context, message: "خطایی در حذف فایل رخ داد لطفا مجددا تلاش کنید");
      } else if (event is DeleteFileSuccessState) {
        dismissDeleteDialog();
        dismissDialog(loadingDialogContext);

        setState(() {
          selectedFiles.clear();
          isSelectable = false;
          files.removeWhere((element) => event.ids.any((e) => e == element.id));
        });

        var itemName = event.ids.length == 1 ? "فایل" : "فایل ها";
        var fel = event.ids.length == 1 ? "شد" : "شدند";

        notify("$itemName با موفقیت حذف $fel");
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
              selectedFiles.clear();
              isSelectable = false;
            });
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "فایل های من",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            automaticallyImplyLeading: false,
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
            actions: [
              IconButton(
                onPressed: _addFile,
                icon: Icon(
                  CupertinoIcons.add,
                ),
              ),
              if (selectedFiles.isNotEmpty)
                IconButton(
                  onPressed: selectedFiles.isNotEmpty
                      ? () {
                    showDeleteDialog(selectedFiles.map((e) => e.id!).toList());
                        }
                      : null,
                  icon: Icon(
                    CupertinoIcons.delete,
                    color: selectedFiles.isNotEmpty ? null : Themes.iconGrey,
                  ),
                  disabledColor: Themes.iconGrey,
                ),
              MyPopupMenuButton(
                itemBuilder: (context) {
                  return [
                    MyPopupMenuItem<String>(
                      value: "new",
                      label: "جدید ترین",
                      withSpace: true,
                      icon: !currentSortType.isFill() ? Icons.check_rounded : null,
                    ),
                    MyPopupMenuItem<String>(
                      value: "old",
                      label: "قدیمی ترین",
                      withSpace: true,
                      icon: currentSortType == "8" ? Icons.check_rounded : null,
                    ),
                    MyPopupMenuItem<String>(
                      value: "pending",
                      label: "در انتظار تایید",
                      withSpace: true,
                      icon: currentSortType == "1" ? Icons.check_rounded : null,
                    ),
                    MyPopupMenuItem<String>(
                      value: "pendingReception",
                      label: "در انتظار پذیرش",
                      withSpace: true,
                      icon: currentSortType == "5" ? Icons.check_rounded : null,
                    ),
                    MyPopupMenuItem<String>(
                      value: "acceptReception",
                      label: "پذیرش شده",
                      withSpace: true,
                      icon: currentSortType == "7" ? Icons.check_rounded : null,
                    ),
                    MyPopupMenuItem<String>(
                      value: "rejectReception",
                      label: "رد شده",
                      withSpace: true,
                      icon: currentSortType == "3" ? Icons.check_rounded : null,
                    ),
                  ];
                },
                onSelected: (value) {
                  _loadFiles(sort: value);
                  setState(() {
                    currentSortType = value;
                  });
                },
                iconData: CupertinoIcons.sort_down,
              ),
              MyPopupMenuButton(
                itemBuilder: (context) {
                  return [
                    MyPopupMenuItem<int>(
                      value: 0,
                      label: "انتخاب همه",
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
                iconData: Icons.more_vert,
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
      if ((state.response?.statusCode ?? 0) == 401) {
        logoutAndGoLogin();
      }

      return Center(
        child: TryAgain(
          onPressed: _loadFiles,
          message: state.response != null ? jDecode(state.response!.body)['message'] : "خطا در دریافت اطلاعات پیش آمد مجدد تلاش کنید",
        ),
      );
    }

    state = state as MyFilesLoadedState;

    files = state.files;

    if (files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "فایلی پیدا نشد جهت ثبت فایل دکمه زیر را کلیک کنید",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RawMaterialButton(
              onPressed: _addFile,
              child: Text(
                "ایجاد فایل",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              elevation: 0.2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
              fillColor: Themes.primary,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Themes.primary,
      onRefresh: () async => _loadFiles(sort: currentSortType),
      child: ListView(
        children: files
            .map<Widget>(
              (file) => GestureDetector(
                onTap: isSelectable ? () => changeSelection(file) : () => onTapFile(file),
                onLongPress: () => changeSelection(file),
                child: MyFileHorizontalItem(
                  file: file,
                  // isSelected: selectedFiles.contains(file),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _loadFiles({String? sort}) {
    bloc.add(MyFilesEvent(sort: sort));
    setState(() {
      selectedFiles.clear();
      isSelectable = false;
    });
  }

  showLoadingDialog({String? message}) {
    showDialog2(
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
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        deleteDialogContext = _;
        var itemName = ids.length == 1 ? "فایل" : "فایل ها";
        return ConfirmDialog(
          dialogContext: context,
          content: 'آیا مایل به حذف ${itemName} هستید؟',
          title: "حذف ${itemName}",
          titleColor: Colors.red,
          onApply: () {
            _deleteFiles(ids);
          },
        );
      },
    );
  }

  dismissDeleteDialog() {
    if (deleteDialogContext != null) {
      Navigator.pop(deleteDialogContext!);
    }
  }

  void logoutAndGoLogin() async {
    User.remove();
    notify("لطفا مجددا وارد حساب کاربری شوید");
    Navigator.pop(context);
  }

  _addFile() {
    push(context, CreateFileFirst());
  }

  changeSelection(MyFile file) {
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
  }

  onTapFile(MyFile file) async {
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
  }

  _deleteFiles(List<int> ids) async {
    deleteFileBloc.add(
      DeleteFileListEvent(
        ids: ids,
        token: await User.getBearerToken(),
      ),
    );
  }
}
