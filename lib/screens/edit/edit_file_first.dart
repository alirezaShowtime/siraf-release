import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:siraf3/bloc/property_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/category.dart' as cat;
import 'package:siraf3/models/edit_file_form_data.dart';
import 'package:siraf3/models/my_file.dart';
import 'package:siraf3/models/my_file_detail.dart';
import 'package:siraf3/models/property_insert.dart';
import 'package:siraf3/money_input_formatter.dart';
import 'package:siraf3/screens/create/properties_screen.dart';
import 'package:siraf3/screens/edit/edit_file_second.dart';
import 'package:siraf3/screens/mark_in_map_screen.dart';
import 'package:siraf3/screens/select_category_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:latlong2/latlong.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:siraf3/models/property.dart' as p;
import 'package:siraf3/dialog.dart';

class EditFileFirst extends StatefulWidget {
  MyFileDetail file;
  EditFileFirst({required this.file, super.key});

  @override
  State<EditFileFirst> createState() => _EditFileFirstState();
}

class _EditFileFirstState extends State<EditFileFirst> {
  cat.Category? category;
  City? city;
  LatLng? location;
  String? address;

  PropertyBloc propertyBloc = PropertyBloc();

  List<PropertyInsert> mainProps = [];
  List<PropertyInsert> otherProps = [];

  Map<String, String> selectedMainProps = {};
  Map<String, String> selectedOtherProps = {};

  List<PropertyInsert> mainFeature = [];
  List<PropertyInsert> otherFeature = [];

  Map<String, String> selectedMainFeatures = {};
  Map<String, String> selectedOtherFeatures = {};

  late EditFileFormData formData;

  @override
  void dispose() {
    super.dispose();

    propertyBloc.close();
  }

  @override
  void initState() {
    super.initState();

    resetEditFileForm = false;

    setData();
  }

  setData() {
    setState(() {
      var c = widget.file.fullCategory;
      category = cat.Category(
        id: c?.id,
        name: c?.name,
        image: c?.image,
        fullCategory: c?.fullCategory,
        isAll: c?.isAll,
        parentId: c?.parentId,
      );

      propertyBloc.add(PropertyInsertEvent(category_id: category!.id!));

      city = widget.file.city;
      address = widget.file.address;
      location = LatLng(
        double.parse(widget.file.lat!),
        double.parse(widget.file.long!),
      );

      formData = EditFileFormData(
        id: widget.file.id!,
        category: category!,
        city: city!,
        location: location!,
        address: address!,
        properties: {},
        description: widget.file.description ?? "",
        title: widget.file.name ?? "",
        ownerPhone: "",
        visitPhone: "",
        estates: [],
        mediaData: MediaData(),
      );
    });
  }

  bool propertiesSetes = false;



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => propertyBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Themes.appBar,
          elevation: 0.7,
          title: Text(
            "ویرایش فایل ${widget.file.id}",
            style: TextStyle(
              color: Themes.text,
              fontSize: 15,
            ),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          actions: [
            IconButton(
              onPressed: () {
                showResetDialog();
              },
              icon: Icon(
                Icons.refresh,
                color: Themes.icon,
              ),
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
                          fontSize: 14,
                          color: Themes.primary,
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
                        value: location != null ? "تغییر" : "تعیین",
                        onTap: _chooseLocation,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      section(
                        title: "آدرس",
                        hint: "تعیین",
                        value: address != null ? "تغییر" : "تعیین",
                        onTap: showAddressDialog,
                      ),
                      if (category != null)
                        BlocBuilder<PropertyBloc, PropertyState>(
                            builder: _buildPropertiesBloc),
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
                    height: 45,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertiesBloc(_context, PropertyState state) {
    if (state is PropertyInitState || state is PropertyLoadingState) {
      return Padding(
        padding: EdgeInsets.only(top: 30),
        child: Center(
          child: SpinKitWave(
            size: 40,
            color: Themes.blue,
            duration: Duration(milliseconds: 1500),
          ),
        ),
      );
    }

    if (state is PropertyErrorState) {
      return Center(
        child: TryAgain(
          onPressed: () {
            if (category == null) return;

            propertyBloc.add(PropertyInsertEvent(category_id: category!.id!));
          },
          message: jDecode(state.response?.body ?? "")['message'],
        ),
      );
    }

    state = state as PropertyLoadedState;

    var props = state.iproperties
      ..sort((a, b) => a.weightInsert!.compareTo(b.weightInsert!));

    mainProps = props.where((element) => element.insert == 1).toList();

    mainFeature = props.where((element) => element.insert == 2).toList();

    otherProps = props.where((element) => element.insert == 3).toList();

    otherFeature = props.where((element) => element.insert == 4).toList();

    if (!propertiesSetes) {
      var selectedProps = props
          .where((e) =>
              widget.file.property?.any((element) {
                return element.key == e.value;
              }) ??
              false)
          .toList();

      selectedMainProps = selectedProps
          .where((element) => element.insert == 1)
          .toList()
          .asMap()
          .map(
            (key, value) => MapEntry(
              value.value ?? "",
              widget.file.property!
                  .firstWhere((element) => element.key! == value.value!)
                  .value
                  .toString(),
            ),
          );

      selectedMainFeatures = selectedProps
          .where((element) => element.insert == 2)
          .toList()
          .asMap()
          .map(
            (key, value) => MapEntry(
              value.value ?? "",
              widget.file.property!
                  .firstWhere((element) => element.key! == value.value!)
                  .value
                  .toString(),
            ),
          );

      selectedOtherProps = selectedProps
          .where((element) => element.insert == 3)
          .toList()
          .asMap()
          .map(
            (key, value) => MapEntry(
              value.value ?? "",
              widget.file.property!
                  .firstWhere((element) => element.key! == value.value!)
                  .value
                  .toString(),
            ),
          );

      selectedOtherFeatures = selectedProps
          .where((element) => element.insert == 4)
          .toList()
          .asMap()
          .map(
            (key, value) => MapEntry(
              value.value ?? "",
              widget.file.property!
                  .firstWhere((element) => element.key! == value.value!)
                  .value
                  .toString(),
            ),
          );

      var properties = <String, String>{};

      properties
        ..addAll(selectedMainProps)
        ..addAll(selectedMainFeatures)
        ..addAll(selectedOtherProps)
        ..addAll(selectedOtherFeatures);

      formData.properties = properties;

      propertiesSetes = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: (mainProps.isNotEmpty
              ? <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "ویژگی ها",
                    style: TextStyle(
                      fontSize: 14,
                      color: Themes.primary,
                      fontFamily: "IranSansBold",
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                ]
              : <Widget>[]) +
          mainProps.map<Widget>((e) {
            String? text;
            if (selectedMainProps.containsKey(e.value!)) {
              if (e.type!.toLowerCase() == "number") {
                text = selectedMainProps[e.value!] as String;

                if (priceFields.contains(e.value!)) {
                  text = number_format(int.parse(text));
                  text += " تومان";
                }

                if (e.value == "prices") {
                  text = "ودیعه :  " + text;
                } else if (e.value == "rent") {
                  if (category!.name!.contains("روز")) {
                    text = "اجاره روزانه : " + text;
                  } else {
                    text = "اجاره ماهیانه : " + text;
                  }
                } else if (e.value == "age") {
                  text = "سال " + text;
                } else if (e.value == "meter") {
                  text += " متر";
                }
              } else {
                var properties = mainProps.where((element) =>
                    element.value == e.value &&
                    (element.items ?? [])
                        .where(
                          (element) =>
                              element.value.toString() ==
                              selectedMainProps[e.value!],
                        )
                        .isNotEmpty);
                if (properties.isNotEmpty) {
                  var item = properties.first.items!.firstWhere((element) =>
                      element.value.toString() == selectedMainProps[e.value!]);
                  text = item.name!;
                }
              }
            }

            return Column(
              children: [
                section(
                  title: e.name ?? "",
                  hint: e.type == "List" ? "انتخاب" : "تعیین",
                  value: text,
                  onTap: () => _onTapProp(e),
                ),
                SizedBox(
                  height: 14,
                ),
              ],
            );
          }).toList() +
          (mainFeature.isNotEmpty
              ? <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "امکانات",
                    style: TextStyle(
                      fontSize: 14,
                      color: Themes.primary,
                      fontFamily: "IranSansBold",
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                ]
              : <Widget>[]) +
          mainFeature.map<Widget>((e) {
            String? text;
            if (selectedMainFeatures.containsKey(e.value!)) {
              if (e.type!.toLowerCase() == "number") {
                text = selectedMainFeatures[e.value!] as String;

                if (priceFields.contains(e.value!)) {
                  text = number_format(int.parse(text));
                  text += " تومان";
                }

                if (e.value == "prices") {
                  text = "ودیعه :  " + text;
                } else if (e.value == "rent") {
                  if (category!.name!.contains("روز")) {
                    text = "اجاره روزانه : " + text;
                  } else {
                    text = "اجاره ماهیانه : " + text;
                  }
                } else if (e.value == "age") {
                  text = "سال " + text;
                } else if (e.value == "meter") {
                  text += " متر";
                }
              } else {
                var properties = mainFeature.where((element) =>
                    element.value == e.value &&
                    (element.items ?? [])
                        .where(
                          (element) =>
                              element.value.toString() ==
                              selectedMainFeatures[e.value!],
                        )
                        .isNotEmpty);
                if (properties.isNotEmpty) {
                  var item = properties.first.items!.firstWhere((element) =>
                      element.value.toString() ==
                      selectedMainFeatures[e.value!]);
                  text = item.name!;
                }
              }
            }

            return Column(
              children: [
                section(
                  title: e.name ?? "",
                  hint: e.type == "List" ? "انتخاب" : "تعیین",
                  value: text,
                  onTap: () => _onTapFeature(e),
                ),
                SizedBox(
                  height: 14,
                ),
              ],
            );
          }).toList() +
          [
            if (otherProps.isNotEmpty)
              section(
                title: "سایر امکانات و ویژگی ها",
                hint: "انتخاب",
                value: (selectedOtherProps.isNotEmpty ||
                        selectedOtherFeatures.isNotEmpty)
                    ? (selectedOtherProps.length + selectedOtherFeatures.length)
                            .toString() +
                        " مورد"
                    : null,
                onTap: _goPropertiesScreen,
              ),
            if (otherProps.isNotEmpty)
              SizedBox(
                height: 14,
              ),
          ],
    );
  }

  _goPropertiesScreen() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PropertiesScreen(
          properties: otherProps,
          features: otherFeature,
          category: category!,
          selectedProps: selectedOtherProps,
          selectedFeatures: selectedOtherFeatures,
        ),
      ),
    );

    if (result is List) {
      setState(() {
        selectedOtherProps = Map<String, String>.from(result[0]);
        selectedOtherFeatures = Map<String, String>.from(result[1]);

        print(selectedOtherProps);
        print(selectedOtherFeatures);
      });
    }
  }

  _onTapProp(PropertyInsert property) {
    if (property.type.toString().toLowerCase() == "number") {
      return showNumberDialog(property);
    } else if (property.type.toString().toLowerCase() == "list") {
      return showListDialog(property);
    }
  }

  _onTapFeature(PropertyInsert property) {
    if (property.type.toString().toLowerCase() == "number") {
      return showFeatureNumberDialog(property);
    } else if (property.type.toString().toLowerCase() == "list") {
      return showFeatureListDialog(property);
    }
  }

  Map<String, String> hints = {
    "meter": "متراژ را به متر وارد کنید",
    "price": "قیمت کل را به تومان وارد کنید",
    "age": "سال ساخت را وارد کنید",
    "prices": "مبلغ ودیعه را به تومان وارد کنید",
    "rent": "مبلغ اجاره را به تومان وارد کنید"
  };

  Map<String, String> helpTexts = {
    "age": "مثال : 1401",
    "prices": "چنانچه مبلغی وارد نشود، به صورت توافقی نمایش داده میشود",
    "rent": "چنانچه مبلغی وارد نشود، به صورت توافقی نمایش داده میشود",
  };

  List<String> priceFields = [
    "price",
    "prices",
    "rent",
  ];

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
        if (category?.id != result.last.id) {
          selectedMainProps.clear();
          selectedMainFeatures.clear();
          selectedOtherProps.clear();
          selectedOtherFeatures.clear();
        }
        category = result.last;

        propertyBloc.add(PropertyInsertEvent(category_id: category!.id!));
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
          selectedCities: city != null ? [city!] : null,
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
          position: location != null
              ? LatLng(location!.latitude, location!.longitude)
              : null,
        ),
      ),
    );

    if (result is LatLng?) {
      setState(() {
        location =
            result != null ? LatLng(result.latitude, result.longitude) : null;
      });
    }
  }

  _resetData() {
    setState(() {
      category = null;
      city = null;
      location = null;
      address = null;

      selectedMainProps = {};
      selectedMainFeatures = {};
      selectedOtherProps = {};
      selectedOtherFeatures = {};
    });
  }

  next() {
    if (category == null) return notify("دسته بندی را انتخاب نمایید");
    if (city == null) return notify("شهر را انتخاب نمایید");
    if (location == null) return notify("موقعیت را روی نقشه انتخاب کنید");
    if (address == null) return notify("فیلد آدرس اجباری است");

    for (PropertyInsert pr in mainProps) {
      if ((pr.require ?? false) && !selectedMainProps.containsKey(pr.value!)) {
        return notify("لطفا " +
            pr.name! +
            " را " +
            (pr.type!.toLowerCase() == "list" ? "انتخاب" : "تعیین") +
            " کنید");
      }
    }

    for (PropertyInsert pr in mainFeature) {
      if ((pr.require ?? false) &&
          !selectedMainFeatures.containsKey(pr.value!)) {
        return notify("لطفا " +
            pr.name! +
            " را " +
            (pr.type!.toLowerCase() == "list" ? "انتخاب" : "تعیین") +
            " کنید");
      }
    }

    for (PropertyInsert pr in otherProps) {
      if ((pr.require ?? false) && !selectedOtherProps.containsKey(pr.value!)) {
        return notify(
            "لطفا وارد سایر امکانات و ویژگی ها شوید و " +
                pr.name! +
                " را " +
                (pr.type!.toLowerCase() == "list" ? "انتخاب" : "تعیین") +
                " کنید",
            duration: Duration(seconds: 4));
      }
    }

    for (PropertyInsert pr in otherFeature) {
      if ((pr.require ?? false) &&
          !selectedOtherFeatures.containsKey(pr.value!)) {
        return notify(
            "لطفا وارد سایر امکانات و ویژگی ها شوید و " +
                pr.name! +
                " را " +
                (pr.type!.toLowerCase() == "list" ? "انتخاب" : "تعیین") +
                " کنید",
            duration: Duration(seconds: 4));
      }
    }

    setState(() {
      selectedMainProps.removeWhere((key, value) => value == "null");
      selectedMainFeatures.removeWhere((key, value) => value == "null");
      selectedOtherProps.removeWhere((key, value) => value == "null");
      selectedOtherFeatures.removeWhere((key, value) => value == "null");
    });

    var properties = <String, String>{};

    properties
      ..addAll(selectedMainProps)
      ..addAll(selectedMainFeatures)
      ..addAll(selectedOtherProps)
      ..addAll(selectedOtherFeatures);

    formData.category = category!;
    formData.city = city!;
    formData.location = location!;
    formData.address = address!;
    formData.properties = properties;

    push(formData);
  }

  push(formData) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditFileSecond(
          formData: formData,
          file: widget.file,
        ),
      ),
    );

    if (resetEditFileForm) {
      _resetData();
    }
  }

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
                fontSize: 13,
                fontFamily: "IranSansMedium",
                color: Themes.text,
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 30,
                ),
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Text(
                  value ?? hint,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "IranSansMedium",
                    color: Themes.text,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
          color: Themes.textGrey.withOpacity(0.5),
          height: 1,
        ),
      ],
    );
  }

  BuildContext? resetDialogContext;

  showResetDialog() {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        resetDialogContext = _;
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
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Text(
                        'آیا مایل به ثبت فایل از ابتدا هستید؟',
                        style: TextStyle(
                          color: Themes.textGrey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: dismissResetDialog,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "خیر",
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
                              onPressed: () {
                                _resetData();
                                dismissResetDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "بله",
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

  dismissResetDialog() {
    if (resetDialogContext != null) {
      Navigator.pop(resetDialogContext!);
    }
  }

  BuildContext? addressDialogContext;

  showAddressDialog() {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        addressDialogContext = _;
        TextEditingController _controller =
            TextEditingController(text: address);
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
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: TextField2(
                        minLines: 6,
                        maxLines: 10,
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "آدرس را بصورت دقیق وارد کنید",
                          hintStyle: TextStyle(
                            color: Themes.textGrey,
                            fontSize: 13,
                            fontFamily: "IranSans",
                          ),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Themes.text,
                          fontSize: 13,
                          fontFamily: "IranSansMedium",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                if (_controller.text.length < 10) {
                                  return notify(
                                      "آدرس باید حداقل 10 کاراکتر باشد");
                                }
                                setState(() {
                                  address = _controller.text.trim().isNotEmpty
                                      ? _controller.text.trim()
                                      : null;
                                });

                                dismissAddressDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "تایید",
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

  dismissAddressDialog() {
    if (addressDialogContext != null) {
      Navigator.pop(addressDialogContext!);
    }
  }

  BuildContext? numberDialog;

  showNumberDialog(PropertyInsert property) {
    StreamController<String> persianNumberText = StreamController();
    persianNumberText.add(
        ((selectedMainProps[property.value!] ?? '').replaceAll(',', ''))
            .toWord());

    StreamController<String?> value = StreamController();
    value.add(selectedMainProps[property.value!]);

    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        numberDialog = _;
        TextEditingController _controller = TextEditingController(
          text: property.value != "age" &&
                  selectedMainProps[property.value!] != null
              ? number_format(
                  int.parse(selectedMainProps[property.value!].toString()))
              : selectedMainProps[property.value!],
        );
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
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: TextField2(
                          maxLines: 1,
                          controller: _controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: hints.containsKey(property.value)
                                ? hints[property.value]
                                : "${property.name!} را وارد کنید",
                            hintStyle: TextStyle(
                              color: Themes.textGrey,
                              fontSize: 13,
                              fontFamily: "IranSans",
                            ),
                          ),
                          onChanged: (v) {
                            persianNumberText.add(v.toWord());
                            value.add(v);
                          },
                          inputFormatters: [
                            if (property.value != "age")
                              MoneyInputFormatter(mantissaLength: 0),
                          ],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Themes.text,
                            fontSize: 13,
                            fontFamily: "IranSansMedium",
                          ),
                        ),
                      ),
                    ),
                    if (helpTexts.containsKey(property.value!))
                      StreamBuilder(
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data.toString().isEmpty) {
                            return Container(
                              height: 20,
                              alignment: Alignment.center,
                              child: Text(
                                helpTexts[property.value!]!,
                                style: TextStyle(
                                  color: Themes.text,
                                  fontSize: 11,
                                  fontFamily: "IranSansMedium",
                                ),
                              ),
                            );
                          }

                          return Container();
                        }),
                        stream: value.stream,
                      ),
                    StreamBuilder(
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data.toString().isEmpty) {
                          return Container(
                            height:
                                helpTexts.containsKey(property.value!) ? 0 : 20,
                          );
                        }
                        String text = snapshot.data.toString();

                        if (priceFields.contains(property.value!)) {
                          text += " تومان";
                        }

                        if (property.value == "prices") {
                          text = "ودیعه :  " + text;
                        } else if (property.value == "rent") {
                          if (category!.name!.contains("روز")) {
                            text = "اجاره روزانه : " + text;
                          } else {
                            text = "اجاره ماهیانه : " + text;
                          }
                        } else if (property.value == "age") {
                          text = "سال " + text;
                        } else if (property.value == "meter") {
                          text += " متر";
                        }

                        return Container(
                          alignment: Alignment.center,
                          height: 20,
                          child: Text(
                            text.trim(),
                            style: TextStyle(
                              color: Themes.text,
                              fontSize: 11,
                              fontFamily: "IranSansMedium",
                            ),
                          ),
                        );
                      }),
                      stream: persianNumberText.stream,
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
                                  if (_controller.text.trim().isNotEmpty) {
                                    selectedMainProps[property.value!] =
                                        _controller.text
                                            .trim()
                                            .replaceAll(',', '');
                                  } else {
                                    selectedMainProps.remove(property.value!);
                                  }
                                });

                                dismissNumberDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "تایید",
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

  dismissNumberDialog() {
    if (numberDialog != null) {
      Navigator.pop(numberDialog!);
    }
  }

  BuildContext? listDialog;

  showListDialog(PropertyInsert property) {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        listDialog = _;
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
                      height: 200,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: property.items!
                            .map<Widget>((e) => buildListItem(e, property))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                dismissListDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "تایید",
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

  dismissListDialog() {
    if (listDialog != null) {
      Navigator.pop(listDialog!);
    }
  }

  BuildContext? numberDialogFeature;

  showFeatureNumberDialog(PropertyInsert property) {
    StreamController<String> persianNumberText = StreamController();
    persianNumberText.add(
        ((selectedMainProps[property.value!] ?? '').replaceAll(',', ''))
            .toWord());

    StreamController<String?> value = StreamController();
    value.add(selectedMainProps[property.value!]);

    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        numberDialogFeature = _;
        TextEditingController _controller = TextEditingController(
          text: selectedMainFeatures[property.value!],
        );
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
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: TextField2(
                          maxLines: 1,
                          controller: _controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: hints.containsKey(property.value)
                                ? hints[property.value]
                                : "${property.name!} را وارد کنید",
                            hintStyle: TextStyle(
                              color: Themes.textGrey,
                              fontSize: 13,
                              fontFamily: "IranSans",
                            ),
                          ),
                          onChanged: (v) {
                            persianNumberText.add(v.toWord());
                            value.add(v);
                          },
                          inputFormatters: [
                            if (property.value != "age")
                              MoneyInputFormatter(mantissaLength: 0),
                          ],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Themes.text,
                            fontSize: 13,
                            fontFamily: "IranSansMedium",
                          ),
                        ),
                      ),
                    ),
                    if (helpTexts.containsKey(property.value!))
                      StreamBuilder(
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data.toString().isEmpty) {
                            return Container(
                              height: 20,
                              alignment: Alignment.center,
                              child: Text(
                                helpTexts[property.value!]!,
                                style: TextStyle(
                                  color: Themes.text,
                                  fontSize: 11,
                                  fontFamily: "IranSansMedium",
                                ),
                              ),
                            );
                          }

                          return Container();
                        }),
                        stream: value.stream,
                      ),
                    StreamBuilder(
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data.toString().isEmpty) {
                          return Container(
                            height:
                                helpTexts.containsKey(property.value!) ? 0 : 20,
                          );
                        }
                        String text = snapshot.data.toString();

                        if (priceFields.contains(property.value!)) {
                          text += " تومان";
                        }

                        if (property.value == "prices") {
                          text = "ودیعه :  " + text;
                        } else if (property.value == "rent") {
                          if (category!.name!.contains("روز")) {
                            text = "اجاره روزانه : " + text;
                          } else {
                            text = "اجاره ماهیانه : " + text;
                          }
                        } else if (property.value == "age") {
                          text = "سال " + text;
                        } else if (property.value == "meter") {
                          text += " متر";
                        }

                        return Container(
                          alignment: Alignment.center,
                          height: 20,
                          child: Text(
                            text.trim(),
                            style: TextStyle(
                              color: Themes.text,
                              fontSize: 11,
                              fontFamily: "IranSansMedium",
                            ),
                          ),
                        );
                      }),
                      stream: persianNumberText.stream,
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
                                  if (_controller.text.trim().isNotEmpty) {
                                    selectedMainFeatures[property.value!] =
                                        _controller.text.trim();
                                  } else {
                                    selectedMainFeatures
                                        .remove(property.value!);
                                  }
                                });

                                dismissNumberDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "تایید",
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

  dismissFeatureNumberDialog() {
    if (numberDialogFeature != null) {
      Navigator.pop(numberDialogFeature!);
    }
  }

  BuildContext? listDialogFeature;

  showFeatureListDialog(PropertyInsert property) {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        listDialogFeature = _;

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
                      height: 200,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: property.items!
                            .map<Widget>((e) =>
                                buildListItem(e, property, isProp: false))
                            .toList(),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                dismissFeatureListDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "تایید",
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

  dismissFeatureListDialog() {
    if (listDialogFeature != null) {
      Navigator.pop(listDialogFeature!);
    }
  }

  Widget buildListItem(Items e, PropertyInsert property, {isProp = true}) {
    var isLast = property.items!.last == e;

    var color;

    if (isProp) {
      color = (selectedMainProps.containsKey(property.value!) &&
              selectedMainProps[property.value!] == e.value.toString())
          ? Themes.secondary
          : Themes.text;
    } else {
      color = (selectedMainFeatures.containsKey(property.value!) &&
              selectedMainFeatures[property.value!] == e.value.toString())
          ? Themes.secondary
          : Themes.text;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isProp) {
            selectedMainProps[property.value!] = e.value.toString();
          } else {
            selectedMainFeatures[property.value!] = e.value.toString();
          }
        });

        if (isProp) {
          dismissListDialog();
        } else {
          dismissFeatureListDialog();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: isLast
                ? BorderSide.none
                : BorderSide(
                    color: Themes.textGrey.withOpacity(0.5),
                    width: 0.7,
                  ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Center(
          child: Text(
            e.name!,
            style: TextStyle(
              fontSize: 13,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
