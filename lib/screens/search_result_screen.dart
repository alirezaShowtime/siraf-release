import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/files_list_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/screens/search_screen.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/file_slide_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/try_again.dart';

class SearchResultScreen extends StatefulWidget {
  FilterData filterData;
  FilterData originalFilterData;

  SearchResultScreen(
      {required this.originalFilterData, required this.filterData, super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  FilesListState currentBlocState = FilesListInitState();

  @override
  void initState() {
    super.initState();

    getViewType();

    scrollController.addListener(pagination);

    homeScreenBloc.stream.listen((event) {
      setState(() {
        currentBlocState = event;
      });

      if (event is FilesListLoadedState) {
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
    return (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) &&
        lastId != null &&
        _hasNewFiles &&
        !_isLoadingMore;
  }

  void pagination() async {
    if (_canLoadMore()) {
      _moreBloc
          .add(FilesListLoadEvent(filterData: widget.filterData, lastId: lastId!));
    }
  }

  void _loadMoreEvent(FilesListState event) {
    setState(() {
      _isLoadingMore = event is FilesListLoadingState;
    });

    if (event is FilesListLoadedState) {
      setState(() {
        _hasNewFiles = event.files.isNotEmpty;

        files.addAll(event.files);

        lastId = event.lastId;
      });
    } else if (event is FilesListErrorState) {
      notify("خطا در بارگزاری ادامه فایل ها رخ داد لطفا مجدد تلاش کنید");
    }
  }

  FilesListBloc _moreBloc = FilesListBloc();

  @override
  void dispose() {
    super.dispose();

    homeScreenBloc.close();
    _moreBloc.close();
  }

  int? lastId;

  bool _isLoadingMore = false;

  List<File> files = [];

  bool _hasNewFiles = true;

  ScrollController scrollController = ScrollController();


  FilesListBloc homeScreenBloc = FilesListBloc();

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
      create: (context) => homeScreenBloc,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.7,
          title: Text(
            "جستجوی \"${widget.filterData.search}\"",
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
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchScreen(
                      originalFilterData: widget.originalFilterData,
                      filterData: widget.filterData,
                    ),
                  ),
                );
              },
              icon: FaIcon(
                CupertinoIcons.search,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentBlocState is FilesListInitState ||
                currentBlocState is FilesListLoadingState)
              Center(
                child: Loading(),
              ),
            if (currentBlocState is FilesListErrorState)
              Center(
                child: TryAgain(
                  onPressed: getFiles,
                  message: (currentBlocState as FilesListErrorState).response != null
                      ? jDecode((currentBlocState as FilesListErrorState)
                          .response!
                          .body)['message']
                      : null,
                ),
              ),
            if (currentBlocState is FilesListLoadedState &&
                (currentBlocState as FilesListLoadedState).files.isEmpty)
              Center(
                child: Text(
                  "فایلی موجود نیست فیلتر را حدف کنید",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            if (currentBlocState is FilesListLoadedState &&
                (currentBlocState as FilesListLoadedState).files.isNotEmpty)
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
                                  padding: EdgeInsets.only(
                                      top: files.first == file ? 0 : 5),
                                  child: viewType == ViewType.List
                                      ? FileHorizontalItem(file: file)
                                      : FileSlideItem(file: file),
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

  // Widget _buildFilesListBloc(BuildContext _, FilesListState state) {
  //   if (state is FilesListInitState || state is FilesListLoadingState) {
  //     return Center(
  //       child: Loading(),
  //     );
  //   }

  //   if (state is FilesListErrorState) {
  //     return Center(
  //       child: TryAgain(
  //         onPressed: getFiles,
  //         message: state.response != null
  //             ? jDecode(state.response!.body)['message']
  //             : null,
  //       ),
  //     );
  //   }

  //   state = state as FilesListLoadedState;

  //   files = state.files;

  //   if (files.isEmpty) {
  //     return Center(
  //       child: Text(
  //         "فایلی موجود نیست فیلتر را حدف کنید",
  //         style: TextStyle(
  //           color: Themes.text,
  //           fontSize: 15,
  //         ),
  //       ),
  //     );
  //   }

  //   return ListView(
  //     controller: scrollController,
  //     children: files
  //             .map<Widget>((file) => GestureDetector(
  //                   onTap: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (_) => FileScreen(id: file.id!),
  //                       ),
  //                     );
  //                   },
  //                   child: Padding(
  //                     padding: EdgeInsets.only(
  //                         top: (state as FilesListLoadedState).files.first == file
  //                             ? 0
  //                             : 5),
  //                     child: viewType == ViewType.List
  //                         ? FileHorizontalItem(file: file)
  //                         : FileSlideItem(file: file),
  //                   ),
  //                 ))
  //             .toList() +
  //         [
  //           if (_isLoadingMore)
  //             Align(
  //               alignment: Alignment.center,
  //               child: Loading(
  //                 backgroundColor: Colors.transparent,
  //               ),
  //             )
  //         ],
  //   );
  // }

  getFiles() {
    homeScreenBloc.add(
      FilesListLoadEvent(
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
