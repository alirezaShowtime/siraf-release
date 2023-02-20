import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/home_screen_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/screens/search_screen.dart';
import 'package:siraf3/themes.dart';
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
  HSState currentBlocState = HSInitState();

  @override
  void initState() {
    super.initState();

    getViewType();

    scrollController.addListener(pagination);

    homeScreenBloc.stream.listen((event) {
      setState(() {
        currentBlocState = event;
      });

      if (event is HSLoadedState) {
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
          .add(HSLoadEvent(filterData: widget.filterData, lastId: lastId!));
    }
  }

  void _loadMoreEvent(HSState event) {
    setState(() {
      _isLoadingMore = event is HSLoadingState;
    });

    if (event is HSLoadedState) {
      setState(() {
        _hasNewFiles = event.files.isNotEmpty;

        files.addAll(event.files);

        lastId = event.lastId;
      });
    } else if (event is HSErrorState) {
      notify("خطا در بارگزاری ادامه فایل ها رخ داد لطفا مجدد تلاش کنید");
    }
  }

  HSBloc _moreBloc = HSBloc();

  int? lastId;

  bool _isLoadingMore = false;

  List<File> files = [];

  bool _hasNewFiles = true;

  ScrollController scrollController = ScrollController();

  List<City> cities = [];

  HSBloc homeScreenBloc = HSBloc();

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
              color: Themes.text,
              fontSize: 15,
            ),
          ),
          backgroundColor: Themes.appBar,
          titleSpacing: 0,
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
                color: Themes.icon,
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
            if (currentBlocState is HSInitState ||
                currentBlocState is HSLoadingState)
              Center(
                child: Loading(),
              ),
            if (currentBlocState is HSErrorState)
              Center(
                child: TryAgain(
                  onPressed: getFiles,
                  message: (currentBlocState as HSErrorState).response != null
                      ? jDecode((currentBlocState as HSErrorState)
                          .response!
                          .body)['message']
                      : null,
                ),
              ),
            if (currentBlocState is HSLoadedState &&
                (currentBlocState as HSLoadedState).files.isEmpty)
              Center(
                child: Text(
                  "فایلی موجود نیست فیلتر را حدف کنید",
                  style: TextStyle(
                    color: Themes.text,
                    fontSize: 15,
                  ),
                ),
              ),
            if (currentBlocState is HSLoadedState &&
                (currentBlocState as HSLoadedState).files.isNotEmpty)
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

  // Widget _buildHSBloc(BuildContext _, HSState state) {
  //   if (state is HSInitState || state is HSLoadingState) {
  //     return Center(
  //       child: Loading(),
  //     );
  //   }

  //   if (state is HSErrorState) {
  //     return Center(
  //       child: TryAgain(
  //         onPressed: getFiles,
  //         message: state.response != null
  //             ? jDecode(state.response!.body)['message']
  //             : null,
  //       ),
  //     );
  //   }

  //   state = state as HSLoadedState;

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
  //                         top: (state as HSLoadedState).files.first == file
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
      HSLoadEvent(
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

  @override
  void dispose() {
    super.dispose();
    homeScreenBloc.close();
  }
}

enum ViewType {
  List,
  Slide;
}
