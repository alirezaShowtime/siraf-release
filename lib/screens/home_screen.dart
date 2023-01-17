import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/home_screen_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/screens/create/create_file_first.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/screens/menu_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/file_slide_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:siraf3/widgets/try_again.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    homeScreenBloc = BlocProvider.of<HSBloc>(context);

    checkIsCitySelected();

    getViewType();
  }

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
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CreateFileFirst()));
            },
            icon: FaIcon(
              OctIcons.sliders_16,
              color: Themes.iconLight,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: () {},
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
          message: state.response != null
              ? jDecode(state.response!.body)['message']
              : null,
        ),
      );
    }

    state = state as HSLoadedState;

    return ListView(
      children: state.files
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
                  padding: EdgeInsets.only(
                      top:
                          (state as HSLoadedState).files.first == file ? 0 : 5),
                  child: viewType == ViewType.List
                      ? FileHorizontalItem(file: file)
                      : FileSlideItem(file: file),
                ),
              ))
          .toList(),
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
