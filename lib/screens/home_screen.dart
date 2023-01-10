import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/home_screen_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/screens/menu_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/file_slide_item.dart';
import 'package:siraf3/widgets/loading.dart';

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
        elevation: 0,
        title: GestureDetector(
          onTap: () => goSelectCity(showSelected: true),
          child: Container(
            color: Themes.appBar,
            padding: const EdgeInsets.all(10),
            child: Text(
              getTitle(cities),
              style: TextStyle(
                color: Themes.text,
                fontSize: 14,
              ),
            ),
          ),
        ),
        backgroundColor: Themes.appBar,
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
              color: Themes.primary,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var sh = await SharedPreferences.getInstance();
              sh.setString("FILE_VIEW_TYPE",
                  viewType == ViewType.List ? "slide" : "list");

              await getViewType();

              getFiles();
            },
            icon: Image(
              image: AssetImage("assets/images/ic_filter.png"),
              width: 24,
              height: 24,
              color: Themes.primary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image(
              image: AssetImage("assets/images/ic_search.png"),
              width: 24,
              height: 24,
              color: Themes.primary,
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
      String? message = jDecode(state.response.body)['message'];

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message ?? "خطایی در هنگام دریافت اطلاعات پیش آمد"),
            SizedBox(
              height: 10,
            ),
            RawMaterialButton(
              onPressed: () {},
              child: Text(
                "تلاش مجدد",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              fillColor: Themes.primary,
            )
          ],
        ),
      );
    }

    state = state as HSLoadedState;

    return ListView(
      children: state.files
          .map<Widget>((file) => Padding(
                padding: EdgeInsets.only(top: 5),
                child: viewType == ViewType.List ? FileHorizontalItem(file: file) : FileSlideItem(file: file),
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
