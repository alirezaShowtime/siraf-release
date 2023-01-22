import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:siraf3/bloc/estate_bloc.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class EstateScreen extends StatefulWidget {
  List<Estate> estates;

  EstateScreen({required this.estates, super.key});

  @override
  State<EstateScreen> createState() => _EstateScreenState();
}

class _EstateScreenState extends State<EstateScreen> {
  List<City> cities = [];

  @override
  void initState() {
    super.initState();

    getCities();
    setEstates();
  }

  getCities() async {
    var mCities = await City.getList();
    setState(() {
      cities = mCities;
    });

    bloc.add(EstateLoadEvent(city_ids: cities.map((e) => e.id!).toList()));
  }

  setEstates() {
    setState(() {
      selectedEstates = widget.estates;
    });
  }

  List<Estate> selectedEstates = [];

  EstateBloc bloc = EstateBloc();

  TextEditingController _searchController = TextEditingController();

  bool mapEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Themes.appBar,
          elevation: 0.7,
          title: TextField2(
            decoration: InputDecoration(
              hintText: "جستجو در دفاتر املاک | " +
                  cities.map((e) => e.name).join(' و '),
              hintStyle: TextStyle(color: Themes.textGrey, fontSize: 13),
              border: InputBorder.none,
            ),
            controller: _searchController,
            style: TextStyle(color: Themes.text, fontSize: 13),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              bloc.add(EstateLoadEvent(
                  city_ids: cities.map((e) => e.id!).toList(), search: value));
            },
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          actions: [
            GestureDetector(
              onTap: () {
                bloc.add(EstateLoadEvent(
                    city_ids: cities.map((e) => e.id!).toList(),
                    search: _searchController.text));
              },
              child: Icon(
                CupertinoIcons.search,
                color: Themes.icon,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            if (!mapEnabled)
              GestureDetector(
                onTap: () {},
                child: Icon(
                  CupertinoIcons.sort_down,
                  color: Themes.icon,
                ),
              ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  mapEnabled = !mapEnabled;
                });

                bloc.add(EstateLoadEvent(
                    city_ids: cities.map((e) => e.id!).toList(),
                    search: _searchController.text));
              },
              child: Icon(
                mapEnabled ? CupertinoIcons.map_fill : CupertinoIcons.map,
                color: Themes.icon,
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.back,
              color: Themes.icon,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<EstateBloc, EstateState>(
                    builder: _buildMainBloc),
              ),
              if (selectedEstates.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: selectedEstates.map<Widget>((e) {
                        return Container(
                          child: Row(children: [
                            Text(
                              e.name!,
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedEstates.remove(e);
                                });
                              },
                              child: Icon(
                                Typicons.delete_outline,
                                color: Color(0xff707070),
                                size: 22,
                              ),
                            )
                          ]),
                        );
                      }).toList()),
                    ),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          selectedEstates,
                        );
                      },
                      color: Themes.primary,
                      child: Text(
                        "تایید",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minWidth: 100,
                      height: 45,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainBloc(BuildContext context, EstateState state) {
    if (state is EstateInitState || state is EstateLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is EstateErrorState) {
      return Center(
        child: TryAgain(
          onPressed: () {
            bloc.add(
              EstateLoadEvent(
                city_ids: cities.map((e) => e.id!).toList(),
                search: _searchController.text,
              ),
            );
          },
        ),
      );
    }

    state = state as EstateLoadedState;

    if (state.estates.isEmpty) {
      return Center(
        child: Text(
          "متاسفانه موردی پیدا نشد",
          style: TextStyle(
            fontSize: 15,
            color: Themes.text,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: state.estates.map<Widget>((e) => buildItem(e)).toList(),
      ),
    );
  }

  Widget buildItem(Estate estate) {
    return GestureDetector(
      onTap: () {
        showDetailsDialog(estate);
      },
      child: Padding(
        padding: EdgeInsets.only(top: 5),
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: RatingBarIndicator(
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 14,
                  unratedColor: Colors.grey,
                  itemPadding: EdgeInsets.symmetric(horizontal: .2),
                  itemBuilder: (context, _) {
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 10,
                    );
                  },
                  rating: 4.2,
                ),
              ),
              Text(
                estate.name! + " | " + estate.address!,
                style: TextStyle(
                  fontSize: 11.5,
                  fontFamily: "IranSansMedium",
                  color: Themes.text,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "مدریت : " + estate.managerName!,
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: "IranSansMedium",
                  color: Themes.textGrey,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 0.7,
                color: Themes.textGrey.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BuildContext? detailsDialog;

  showDetailsDialog(Estate estate) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        detailsDialog = _;
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
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                estate.name!,
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 14,
                                ),
                              ),
                              RatingBarIndicator(
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 14,
                                unratedColor: Colors.grey,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: .2),
                                itemBuilder: (context, _) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 10,
                                  );
                                },
                                rating: 4.2,
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "مدیریت : " + estate.managerName!,
                                style: TextStyle(
                                  color: Themes.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "امتیار 4/4 از 5",
                                style: TextStyle(
                                  color: Themes.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "موبایل : " + estate.phoneNumber!,
                                style: TextStyle(
                                  color: Themes.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "تلفن : " + "02133333333",
                                style: TextStyle(
                                  color: Themes.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                          Text(
                            "آدرس : " + estate.address!,
                            style: TextStyle(
                              color: Themes.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  if (selectedEstates.contains(estate)) {
                                    selectedEstates.remove(estate);
                                  } else {
                                    selectedEstates.add(estate);
                                  }
                                });

                                dismissDetailsDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                selectedEstates.contains(estate)
                                    ? "حذف"
                                    : "افزودن",
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
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "مشاهده پروفایل",
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

  dismissDetailsDialog() {
    if (detailsDialog != null) {
      Navigator.pop(detailsDialog!);
    }
  }
}
