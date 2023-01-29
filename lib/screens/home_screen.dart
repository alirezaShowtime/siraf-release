import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/home_screen_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/screens/filter_screen.dart';
import 'package:siraf3/screens/menu_screen.dart';
import 'package:siraf3/screens/search_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/file_slide_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/try_again.dart';

class HomeScreen extends StatefulWidget {
  MaterialPageRoute? nextScreen;

  HomeScreen({this.nextScreen, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.nextScreen != null) {
      Navigator.push(context, widget.nextScreen!);
      return;
    }

    homeScreenBloc = BlocProvider.of<HSBloc>(context);

    checkIsCitySelected();

    getViewType();

    scrollController.addListener(pagination);

    homeScreenBloc.stream.listen((event) {
      if (event is HSLoadedState) {
        print(event.files.length);
        setState(() {
          _hasNewFiles = event.files.isNotEmpty;
          lastId = event.lastId;
        });
      }
    });

    _moreBloc.stream.listen(_loadMoreEvent);
  }

  HSBloc _moreBloc = HSBloc();

  int? lastId;

  bool _isLoadingMore = false;

  List<File> files = [];

  bool _hasNewFiles = true;

  bool _canLoadMore() {
    return (scrollController.position.pixels == scrollController.position.maxScrollExtent) && lastId != null && _hasNewFiles && !_isLoadingMore;
  }

  void pagination() async {
    if (_canLoadMore()) {
      // scrollController.animateTo(scrollController.position.maxScrollExtent,
      //     duration: const Duration(milliseconds: 1),
      //     curve: Curves.fastOutSlowIn);
      _moreBloc.add(HSLoadEvent(cities: cities, lastId: lastId!));
    }
  }

  void _loadMoreEvent(HSState event) {
    setState(() {
      _isLoadingMore = event is HSLoadingState;
    });

    if (event is HSLoadedState) {
      setState(() {
        _hasNewFiles = event.files.isNotEmpty;

        files += event.files;

        lastId = event.lastId;

        print(files.length);
      });
    } else if (event is HSErrorState) {
      notify("خطا در بارگزاری ادامه فایل ها رخ داد لطفا مجدد تلاش کنید");
    }
  }

  ScrollController scrollController = ScrollController();

  List<City> cities = [];

  late HSBloc homeScreenBloc;

  checkIsCitySelected() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getBool("isFirstOpen") ?? true) {
      await sharedPreferences.setBool("isFirstOpen", false);
      goSelectCity();
    } else {
      var mCities = await City.getList();
      setState(() {
        cities = mCities;
      });

      getFiles();
    }
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
    sh.setString("FILE_VIEW_TYPE", viewType == ViewType.List ? "slide" : "list");

    await getViewType();

    getFiles();
  }

  goSelectCity({showSelected = false}) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SelectCityScreen(showSelected: showSelected)));
  }

  openMenu() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen()));
  }

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
              color: Themes.textLight,
              fontSize: 15,
            ),
          ),
        ),
        backgroundColor: Themes.primary,
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
              color: Themes.iconLight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              changeViewType();
            },
            icon: FaIcon(
              OctIcons.image_24,
              color: Themes.iconLight,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (_) => FilterScreen()));
            },
            icon: FaIcon(
              OctIcons.sliders_16,
              color: Themes.iconLight,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchScreen()));
            },
            icon: FaIcon(
              CupertinoIcons.search,
              color: Themes.iconLight,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: BlocBuilder<HSBloc, HSState>(builder: _buildHSBloc),
    );
  }

  Widget _buildHSBloc(BuildContext _, HSState state) {
    if (state is HSInitState || state is HSLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is HSErrorState) {
      return Center(
        child: TryAgain(
          onPressed: getFiles,
          message: state.response != null ? jDecode(state.response!.body)['message'] : null,
        ),
      );
    }

    state = state as HSLoadedState;

    files = state.files;

    return ListView(
      controller: scrollController,
      children: files
              .map<Widget>((file) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FileScreen(id: file.id!),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: (state as HSLoadedState).files.first == file ? 0 : 5),
                      child: viewType == ViewType.List ? FileHorizontalItem(file: file) : FileSlideItem(file: file),
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
    );
  }

  getFiles() {
    homeScreenBloc.add(HSLoadEvent(cities: cities));
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
