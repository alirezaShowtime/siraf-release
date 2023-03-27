import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/home_screen_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/screens/filter_screen.dart';
import 'package:siraf3/screens/intro_screen.dart';
import 'package:siraf3/screens/menu_screen.dart';
import 'package:siraf3/screens/search_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/file_slide_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/try_again.dart';

import 'package:badges/badges.dart' as badges;
import 'package:uni_links/uni_links.dart';

class HomeScreen extends StatefulWidget {
  MaterialPageRoute? nextScreen;

  HomeScreen({this.nextScreen, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FilterData filterData = FilterData();

  @override
  void initState() {
    super.initState();

    listenLink();

    if (widget.nextScreen != null) {
      Navigator.push(context, widget.nextScreen!);
      return;
    }

    homeScreenBloc = BlocProvider.of<HSBloc>(context);

    checkScreen();

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
          currentBlocState = event;
          files = event.files;
        });
      }
    });

    _moreBloc.stream.listen(_loadMoreEvent);
  }

  HSBloc _moreBloc = HSBloc();

  int? lastId;

  bool _isLoadingMore = false;

  bool _hasNewFiles = true;

  List<File> files = [];

  bool _canLoadMore() {
    return (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) &&
        lastId != null &&
        !_isLoadingMore;
  }

  void pagination() async {
    if (_canLoadMore()) {
      if (_moreBloc.isClosed) {
        _moreBloc = HSBloc();
      }
      _moreBloc.add(HSLoadEvent(filterData: filterData, lastId: lastId!));
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

  ScrollController scrollController = ScrollController();

  List<City> cities = [];

  late HSBloc homeScreenBloc;

  checkScreen() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getBool("isFirstOpen") ?? true) {
      await sharedPreferences.setBool("isFirstOpen", false);
      goSelectCity();
      return;
    }

    var mCities = await City.getList();
    setState(() {
      cities = mCities;

      filterData = filterData..cityIds = cities.map<int>((e) => e.id!).toList();
    });
    getFiles();
  }

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

  changeViewType() async {
    var sh = await SharedPreferences.getInstance();
    sh.setString(
        "FILE_VIEW_TYPE", viewType == ViewType.List ? "slide" : "list");

    await getViewType();

    getFiles();
  }

  goSelectCity({showSelected = false}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SelectCityScreen(showSelected: showSelected)));
  }

  openMenu() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen()));
  }

  // @override
  // void dispose() {
  //   super.dispose();

  //   homeScreenBloc.close();
  //   _moreBloc.close();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.7,
        title: GestureDetector(
          onTap: () => goSelectCity(showSelected: true),
          child: Text(
            getTitle(cities),
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            onPressed: () {
              openMenu();
            },
            icon: Image(
              image: AssetImage("assets/images/ic_menu.png"),
              width: 30,
              height: 30,
              color: App.theme.iconTheme.color,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FilterScreen(
                    originalFilterData: FilterData(
                        cityIds: cities.map<int>((e) => e.id!).toList()),
                    filterData: filterData,
                  ),
                ),
              );

              if (result != null && result is FilterData) {
                setState(() {
                  filterData = result;
                });

                print(filterData.toQueryString());

                getFiles();
              }
            },
            icon: badges.Badge(
              badgeContent: Text(''),
              showBadge: filterData.hasFilter(),
              position: badges.BadgePosition.custom(top: -15, start: -10),
              badgeStyle: badges.BadgeStyle(badgeColor: Themes.primary),
              child: FaIcon(
                OctIcons.sliders_16,
                size: 20,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              var originalFilterData = this.filterData;
              var filterData = this.filterData;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(
                    originalFilterData: originalFilterData,
                    filterData: filterData,
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
    );
  }

  void _scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  HSState currentBlocState = HSInitState();

  getFiles() {
    if (homeScreenBloc.isClosed) {
      homeScreenBloc = HSBloc();
    }
    homeScreenBloc.add(
      HSLoadEvent(
        filterData: filterData,
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

  void listenLink() {
    if (!kIsWeb) {
      uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        debugPrint('Received URI: $uri');
        RegExp reg = new RegExp(r'https://siraf.biz/([0-9]+)');

        if (!reg.hasMatch(uri.toString())) {
          return notify("صفحه ای برای نمایش پیدا نشد");
        }

        var match = reg.firstMatch(uri.toString());
        var id = match!.group(1);

        if (id == null) {
          return notify("صفحه ای برای نمایش پیدا نشد");
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FileScreen(
              id: int.parse(id),
            ),
          ),
        );
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        notify("لینک قابل پردازش نیست");
      });
    }
  }
}

enum ViewType {
  List,
  Slide;
}
