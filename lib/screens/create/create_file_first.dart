import 'package:flutter/material.dart';
import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/screens/mark_in_map_screen.dart';
import 'package:siraf3/screens/select_category_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:latlong2/latlong.dart';

class CreateFileFirst extends StatefulWidget {
  const CreateFileFirst({super.key});

  @override
  State<CreateFileFirst> createState() => _CreateFileFirstState();
}

class _CreateFileFirstState extends State<CreateFileFirst> {
  Category? category;
  City? city;
  LatLng? _selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Themes.appBar,
        elevation: 0.7,
        title: Text(
          "ثبت فایل",
          style: TextStyle(
            color: Themes.text,
            fontSize: 15,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _resetData();
            },
            icon: Icon(
              Icons.refresh,
              color: Themes.icon,
            ),
          ),
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Themes.icon,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "مشخصات کلی",
                      style: TextStyle(
                        fontSize: 13,
                        color: Themes.text,
                        fontFamily: "IranSansBold",
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    section(
                      title: "دسته بندی",
                      hint: "انتخاب",
                      value: category?.name,
                      onTap: _selectCategory,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    section(
                      title: "شهر",
                      hint: "انتخاب",
                      value: city?.name,
                      onTap: _selectCity,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    section(
                      title: "موقعیت بر روی نقشه",
                      hint: "تعیین",
                      value: null,
                      onTap: _chooseLocation,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    section(
                      title: "آدرس",
                      hint: "تعیین",
                      value: null,
                      onTap: _enterAddress,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: next,
                  color: Themes.primary,
                  child: Text(
                    "بعدی",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minWidth: 100,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _selectCategory() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategorySelectScreen(
          filterIsAllCategories: true,
        ),
      ),
    );
    if (result != null || result is List<Category>) {
      setState(() {
        category = result.last;

        // _listSpecificationsSelected.clear();
        // _numberSpecificationValues.clear();

        // BlocProvider.of<SpecBloc>(context)
        //     .add(SpecFetchEvent(category: _selectedCategory!));
      });
    }
  }

  _selectCity() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectCityScreen(
          max: 1,
          saveCity: false,
          force: true,
        ),
      ),
    );
    if (result != null || result is List<City>) {
      setState(() {
        city = result.first;
      });
    }
  }

  _chooseLocation() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MarkInMapScreen(
          position: _selectedPosition != null
              ? LatLng(_selectedPosition!.latitude, _selectedPosition!.latitude)
              : null,
        ),
      ),
    );

    if (result is LatLng?) {
      setState(() {
        _selectedPosition =
            result != null ? LatLng(result.latitude, result.longitude) : null;
      });
    }
  }

  _enterAddress() {
    print("select cat");
  }

  _resetData() {
    // todo implement
  }

  next() {}

  Widget section(
      {required String title,
      required String hint,
      required String? value,
      required Function() onTap}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Themes.text,
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: 12,
                  color: Themes.text,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
          color: Themes.primary.withOpacity(0.5),
          height: 1,
        ),
      ],
    );
  }
}
