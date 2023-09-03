import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/consultant_files_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/widgets/empty.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/file_slide_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/try_again.dart';

class ConsultantFilesScreen extends StatefulWidget {
  FilterData filterData;
  String? appBarTitle;

  ConsultantFilesScreen({required this.filterData, this.appBarTitle, super.key});

  @override
  State<ConsultantFilesScreen> createState() => _ConsultantFilesScreenState();
}

class _ConsultantFilesScreenState extends State<ConsultantFilesScreen> {
  FilesState currentBlocState = FilesInitState();

  @override
  void initState() {
    super.initState();

    getViewType();

    scrollController.addListener(pagination);

    consultantFilesBloc.stream.listen((event) {
      setState(() {
        currentBlocState = event;
      });

      if (event is FilesLoadedState) {
        setState(() {
          _hasNewFiles = event.files.isNotEmpty;
          lastId = event.lastId;
          files = event.files;
        });
      }
    });

    _moreBloc.stream.listen(_loadMoreEvent);

    getFiles();
  }

  bool _canLoadMore() {
    return (scrollController.position.pixels == scrollController.position.maxScrollExtent) && lastId != null && _hasNewFiles && !_isLoadingMore;
  }

  void pagination() async {
    if (_canLoadMore()) {
      _moreBloc.add(FilesLoadEvent(filterData: widget.filterData, lastId: lastId!));
    }
  }

  void _loadMoreEvent(FilesState event) {
    setState(() {
      _isLoadingMore = event is FilesLoadingState;
    });

    if (event is FilesLoadedState) {
      setState(() {
        _hasNewFiles = event.files.isNotEmpty;

        files.addAll(event.files);

        lastId = event.lastId;
      });
    } else if (event is FilesErrorState) {
      notify("خطا در بارگزاری ادامه فایل ها رخ داد لطفا مجدد تلاش کنید");
    }
  }

  ConsultantFilesBloc _moreBloc = ConsultantFilesBloc();

  @override
  void dispose() {
    super.dispose();

    consultantFilesBloc.close();
    _moreBloc.close();
  }

  int? lastId;

  bool _isLoadingMore = false;

  List<File> files = [];

  bool _hasNewFiles = true;

  ScrollController scrollController = ScrollController();

  ConsultantFilesBloc consultantFilesBloc = ConsultantFilesBloc();

  ViewType viewType = ViewType.List;

  getViewType() async {
    var sh = await SharedPreferences.getInstance();

    setState(() {
      viewType = sh.getString("FILE_VIEW_TYPE") != null
          ? sh.getString("FILE_VIEW_TYPE") == "list"
              ? ViewType.List
              : ViewType.Slide
          : ViewType.List;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => consultantFilesBloc,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.7,
          title: Text(
            widget.appBarTitle ?? "لیست فایل های مشاور",
            style: TextStyle(
              fontSize: 13,
            ),
          ),
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: MyBackButton(),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentBlocState is FilesInitState || currentBlocState is FilesLoadingState)
              Center(
                child: Loading(),
              ),
            if (currentBlocState is FilesErrorState)
              Center(
                child: TryAgain(
                  onPressed: getFiles,
                  message: (currentBlocState as FilesErrorState).response != null ? jDecode((currentBlocState as FilesErrorState).response!.body)['message'] : null,
                ),
              ),
            if (currentBlocState is FilesLoadedState && (currentBlocState as FilesLoadedState).files.isEmpty)
              Center(
                child: Empty(),
              ),
            if (currentBlocState is FilesLoadedState && (currentBlocState as FilesLoadedState).files.isNotEmpty)
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: files
                          .map<Widget>((file) => InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FileScreen(id: file.id!),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: files.first == file ? 0 : 5),
                                  child: FileHorizontalItem(file: file),
                                ),
                              ))
                          .toList() +
                      [
                        if (_isLoadingMore)
                          Align(
                            alignment: Alignment.center,
                            child: Loading(
                              backgroundColor: Colors.transparent,
                            ),
                          )
                      ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  getFiles() {
    consultantFilesBloc.add(
      FilesLoadEvent(
        filterData: widget.filterData,
      ),
    );
  }

  String getTitle(List<City> cities) {
    return cities.isEmpty
        ? "انتخاب شهر"
        : cities.length == 1
            ? cities.first.name ?? "${cities.length} شهر"
            : "${cities.length} شهر";
  }
}

enum ViewType {
  List,
  Slide;
}
