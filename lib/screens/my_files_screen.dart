import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/my_files_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/my_file.dart';
import 'package:siraf3/screens/create/create_file_first.dart';
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

  MyFilesBloc bloc = MyFilesBloc();

  @override
  void initState() {
    super.initState();

    _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
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
              Navigator.pop(context);
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
              onPressed: selectedFiles.isNotEmpty ? () {} : null,
              icon: Icon(
                CupertinoIcons.delete,
                color: selectedFiles.isNotEmpty ? Themes.icon : Themes.iconGrey,
              ),
              disabledColor: Themes.iconGrey,
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "جدید ترین",
                      style: TextStyle(
                        fontSize: 13,
                        color: Themes.text,
                      ),
                    ),
                    height: 35,
                  ),
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "قدیمی ترین",
                      style: TextStyle(
                        fontSize: 13,
                        color: Themes.text,
                      ),
                    ),
                    height: 35,
                  ),
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "در انتظار تایید",
                      style: TextStyle(
                        fontSize: 13,
                        color: Themes.text,
                      ),
                    ),
                    height: 35,
                  ),
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "در انتظار پذیرش",
                      style: TextStyle(
                        fontSize: 13,
                        color: Themes.text,
                      ),
                    ),
                    height: 35,
                  ),
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "پذیرش شده",
                      style: TextStyle(
                        fontSize: 13,
                        color: Themes.text,
                      ),
                    ),
                    height: 35,
                  ),
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "رد شده",
                      style: TextStyle(
                        fontSize: 13,
                        color: Themes.text,
                      ),
                    ),
                    height: 35,
                  ),
                ];
              },
              onSelected: (value) {},
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
    );
  }

  Widget _buildMainBloc(BuildContext context, MyFilesState state) {
    if (state is MyFilesLoadingState || state is MyFilesInitState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is MyFilesErrorState) {
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
                onTap: () {
                  // todo go to file screen
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

  void _loadFiles() {
    bloc.add(MyFilesEvent());
    setState(() {
      selectedFiles.clear();
    });
  }
}
