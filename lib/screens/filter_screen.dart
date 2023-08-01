import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:siraf3/bloc/categories_bloc.dart';
import 'package:siraf3/bloc/property_bloc.dart';
import 'package:siraf3/bloc/total_file_bloc.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/models/property_insert.dart';
import 'package:siraf3/money_input_formatter.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/text_form_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:siraf3/widgets/usefull/text/light/text_normal_light.dart';

class FilterScreen extends StatefulWidget {
  FilterData originalFilterData;
  FilterData filterData;
  String? total_url;

  FilterScreen({required this.originalFilterData, required this.filterData, required this.total_url, super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  CategoriesBloc categoriesBloc = CategoriesBloc();
  PropertyBloc propertyBloc = PropertyBloc();

  StreamController<List<Category>> subCategories = StreamController();

  TotalFileBloc totalFileBloc = TotalFileBloc(url: "");

  bool _hasImage = false;
  bool _hasVideo = false;
  bool _hasTour = false;

  List<Category> categories = [];
  Map<String, String> propFilters = {};

  int totalFilters = 0;

  @override
  void dispose() {
    super.dispose();

    categoriesBloc.close();
    propertyBloc.close();
  }

  @override
  void initState() {
    super.initState();

    if (widget.total_url != null) totalFileBloc = TotalFileBloc(url: widget.total_url!);

    categoriesBloc.add(CategoriesFetchEvent());
    categoriesBloc.stream.listen((event) {
      if (event is CategoriesBlocLoaded) {
        categories = event.categories;

        if (widget.filterData.category != null) {
          setMainCat(widget.filterData.mainCategory);
          _subCategory = widget.filterData.category;

          propertyBloc.add(PropertyInsertEvent(category_id: _subCategory!.id!, type: "filter"));

          _hasImage = widget.filterData.hasImage ?? false;
          _hasVideo = widget.filterData.hasVideo ?? false;
          _hasTour = widget.filterData.hasTour ?? false;

          var filterNumeric = widget.filterData.filters ?? Filters();

          if (filterNumeric.prices?.length == 2 && filterNumeric.prices![1] == 99999999999999999) {
            filterNumeric.prices = [
              filterNumeric.prices![0],
            ];
          }

          if (filterNumeric.price?.length == 2 && filterNumeric.price![1] == 99999999999999999) {
            filterNumeric.price = [
              filterNumeric.price![0],
            ];
          }

          if (filterNumeric.rent?.length == 2 && filterNumeric.rent![1] == 99999999999999999) {
            filterNumeric.rent = [
              filterNumeric.rent![0],
            ];
          }

          if (filterNumeric.mater?.length == 2 && filterNumeric.mater![1] == 99999999999999999) {
            filterNumeric.mater = [
              filterNumeric.mater![0],
            ];
          }

          filters = filterNumeric;

          onChangeFilter();

          if (filterNumeric.prices?.length == 2 && filterNumeric.prices![1] == 99999999999999999) {
            filterNumeric.prices = [
              filterNumeric.prices![0],
            ];
          }

          if (filterNumeric.price?.length == 2 && filterNumeric.price![1] == 99999999999999999) {
            filterNumeric.price = [
              filterNumeric.price![0],
            ];
          }

          if (filterNumeric.rent?.length == 2 && filterNumeric.rent![1] == 99999999999999999) {
            filterNumeric.rent = [
              filterNumeric.rent![0],
            ];
          }

          if (filterNumeric.mater?.length == 2 && filterNumeric.mater![1] == 99999999999999999) {
            filterNumeric.mater = [
              filterNumeric.mater![0],
            ];
          }

          filters = filterNumeric;
        } else {
          setMainCat(event.categories.where((element) => element.parentId == null).first);

          onChangeFilter();
        }
      }
    });
  }

  setFilterData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => categoriesBloc),
        BlocProvider<TotalFileBloc>(create: (_) => totalFileBloc),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: BlocBuilder<CategoriesBloc, CategoriesBlocState>(builder: _buildMainWidgets),
        ),
      ),
    );
  }

  Widget _buildMainWidgets(BuildContext context, state) {
    if (state is CategoriesBlocLoading) {
      return Center(
        child: Loading(),
      );
    }

    if (state is CategoriesBlocLoaded) {
      return _buildMainWidgetWithCategories(state.categories);
    }

    if (state is CategoriesBlocError) {
      return Center(
        child: TryAgain(
          onPressed: () {
            categoriesBloc.add(CategoriesFetchEvent());
          },
        ),
      );
    }

    return Container();
  }

  Widget _buildMainWidgetWithCategories(List<Category> categories) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: App.theme.backgroundColor,
      child: Stack(
        children: [
          if (!App.isDark)
            Image(
              image: AssetImage("assets/images/filter_background.png"),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                ],
                tileMode: TileMode.clamp,
                begin: Alignment(0, -1),
                end: Alignment(0, 0),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              CupertinoIcons.back,
                              color: Themes.iconLight,
                              size: 20,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              right: 5,
                              bottom: 10,
                            ),
                            child: Text(
                              "فیلتر",
                              style: TextStyle(color: Themes.textLight, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.filterData = widget.originalFilterData;

                            _mainCategory = null;
                            _subCategory = null;

                            propertyBloc.add(PropertyInsertEvent(category_id: null, type: "filter"));

                            filters = Filters();
                            _hasImage = false;
                            _hasVideo = false;
                            _hasTour = false;
                          });

                          _onTapSubmit();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            "حذف همه" + (totalFilters > 0 ? "($totalFilters)" : ""),
                            style: TextStyle(color: Themes.textLight, fontSize: 13),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(color: App.theme.dialogBackgroundColor, borderRadius: BorderRadius.circular(60), boxShadow: [
                          BoxShadow(
                            offset: Offset(-1, 0),
                            color: App.theme.shadowColor,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            offset: Offset(1, 0),
                            color: App.theme.shadowColor,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            offset: Offset(0, 0),
                            color: App.theme.shadowColor,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            offset: Offset(1, 1),
                            color: App.theme.shadowColor,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            offset: Offset(-1, -1),
                            color: App.theme.shadowColor,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ]),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: categories.where((element) => element.parentId == null).map<Widget>((e) => _mainCategoryItem(categories, e)).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // if (_mainCategory != null)
                      Container(
                        decoration: BoxDecoration(
                          color: App.theme.dialogBackgroundColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-1, 0),
                              color: App.theme.shadowColor,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              offset: Offset(1, 0),
                              color: App.theme.shadowColor,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              offset: Offset(0, 0),
                              color: App.theme.shadowColor,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              offset: Offset(1, 1),
                              color: App.theme.shadowColor,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              offset: Offset(-1, -1),
                              color: App.theme.shadowColor,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              height: 30,
                              child: StreamBuilder(
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData && snapshot.data != null && (snapshot.data as List<Category>).isNotEmpty) {
                                    var items = (snapshot.data as List<Category>).map<Widget>((e) => _subCategoryItem(e)).toList();
                                    if (items.length <= 3) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: items
                                            .map<Widget>((e) => Expanded(
                                                  child: e,
                                                ))
                                            .toList(),
                                      );
                                    }
                                    return ListView(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children: items,
                                    );
                                  }
                                  return Container();
                                }),
                                stream: subCategories.stream,
                              ),
                            ),
                            StreamBuilder(
                              builder: _buildFields,
                              stream: propertyBloc.stream,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Transform.translate(
                              offset: Offset(0, 5),
                              child: RawMaterialButton(
                                onPressed: _onTapSubmit,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextNormalLight("اعمال فیلتر"),
                                    BlocBuilder<TotalFileBloc, TotalFileState>(builder: _buildTotalFileBloc),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                ),
                                elevation: 0,
                                constraints: BoxConstraints(
                                  minHeight: 45,
                                  minWidth: double.infinity,
                                ),
                                fillColor: Themes.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Category? _mainCategory;

  _mainCategoryItem(List<Category> categories, Category e) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 7,
          bottom: 7,
          left: 5,
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              setMainCat(e);
            });

            onChangeFilter();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: _mainCategory?.id == e.id ? Themes.primary : Colors.transparent,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 12,
            ),
            alignment: Alignment.center,
            child: Text(
              e.name!,
              style: TextStyle(
                color: App.isDark
                    ? Themes.textLight
                    : _mainCategory?.id == e.id
                        ? Themes.textLight
                        : Themes.text,
                fontSize: 11,
                fontFamily: "IranSansMedium",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Category? _subCategory;

  _subCategoryItem(Category e) {
    return GestureDetector(
      onTap: () {
        if (_subCategory?.id == e.id!) return;

        setState(() {
          _subCategory = e;

          filters = Filters();
        });
        onChangeFilter();

        propertyBloc.add(PropertyInsertEvent(category_id: _subCategory!.id!, type: "filter"));
      },
      child: Container(
        constraints: BoxConstraints(
          minWidth: (MediaQuery.of(context).size.width - 40) / 4,
        ),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
            color: _subCategory?.id == e.id ? Themes.primary : Themes.secondary2.withOpacity(0.5),
            width: 1,
          )),
        ),
        alignment: Alignment.center,
        child: Text(
          e.name ?? "",
          style: TextStyle(
            color: App.isDark
                ? _subCategory?.id == e.id
                    ? DarkThemes.textLight
                    : DarkThemes.textMediumLight
                : _subCategory?.id == e.id
                    ? Themes.text
                    : Themes.secondary2,
            fontSize: 13,
            fontFamily: _subCategory?.id == e.id ? "IranSansMedium" : null,
          ),
        ),
      ),
    );
  }

  List<String> numberFieldsText = [
    "price",
    "prices",
    "rent",
    "meter",
  ];

  Filters filters = Filters();

  Widget _buildFields(BuildContext context, AsyncSnapshot<PropertyState> snapshot) {
    if (!snapshot.hasData) {
      return Container(
        height: 160,
      );
    }

    if (snapshot.data is PropertyLoadedState) {
      var props = (snapshot.data! as PropertyLoadedState).iproperties;

      props = props.where((element) => numberFieldsText.any((e) => e == element.value)).toList();

      props.sort((a, b) => numberFieldsText.indexOf(a.value!).compareTo(numberFieldsText.indexOf(b.value!)));

      filters = filters;

      var widgets = <Widget>[];

      for (PropertyInsert p in props) {
        var data = [];

        switch (p.value) {
          case 'meter':
            data = filters.mater ?? [];
            break;
          case 'price':
            data = filters.price ?? [];
            break;
          case 'rent':
            data = filters.rent ?? [];
            break;
          case 'prices':
            data = filters.prices ?? [];
        }

        var minInitialValue = data.asMap().containsKey(0) ? (data[0] == 0 ? "" : data[0]) : "";
        var maxInitialValue = data.asMap().containsKey(1)
            ? data[1] == 0
                ? ""
                : data[1]
            : "";

        widgets.addAll(
          [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name!,
                    style: TextStyle(
                      color: App.isDark ? DarkThemes.textMediumLight : Themes.secondary2,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 3),
                  if (p.isPrice())
                    Text(
                      "(تومان)",
                      style: TextStyle(
                        color: App.isDark ? DarkThemes.textMediumLight : Themes.secondary2,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField2(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(
                              color: Themes.secondary2,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(
                              color: Themes.secondary2,
                              width: 1,
                            ),
                          ),
                          hintText: "حداقل",
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Themes.textGrey,
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        initialValue: minInitialValue.toString(),
                        inputFormatters: [MoneyInputFormatter(mantissaLength: 0)],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onChanged: (v) {
                          v = v.replaceAll(',', '');

                          var data = <int>[];

                          switch (p.value) {
                            case 'meter':
                              data = filters.mater ?? [];
                              break;
                            case 'price':
                              data = filters.price ?? [];
                              break;
                            case 'rent':
                              data = filters.rent ?? [];
                              break;
                            case 'prices':
                              data = filters.prices ?? [];
                          }

                          if (v.isEmpty) {
                            data = [0, if (data.length > 1) data[1]];
                          } else {
                            data = [int.parse(v), if (data.length > 1) data[1]];
                          }

                          switch (p.value) {
                            case "meter":
                              filters.mater = data;
                              break;
                            case "price":
                              filters.price = data;
                              break;
                            case "rent":
                              filters.rent = data;
                              break;
                            case "prices":
                              filters.prices = data;
                              break;
                            default:
                          }

                          onChangeFilter();
                        },
                        style: TextStyle(
                          fontSize: 13,
                          color: App.theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField2(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(
                              color: Themes.secondary2,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(
                              color: Themes.secondary2,
                              width: 1,
                            ),
                          ),
                          hintText: "حداکثر",
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Themes.textGrey,
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        initialValue: maxInitialValue.toString(),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        inputFormatters: [MoneyInputFormatter(mantissaLength: 0)],
                        onChanged: (v) {
                          v = v.replaceAll(',', '');

                          var data = <int>[];

                          switch (p.value) {
                            case 'meter':
                              data = filters.mater ?? [];
                              break;
                            case 'price':
                              data = filters.price ?? [];
                              break;
                            case 'rent':
                              data = filters.rent ?? [];
                              break;
                            case 'prices':
                              data = filters.prices ?? [];
                          }

                          if (v.isEmpty) {
                            data = [data.length > 0 ? data[0] : 0];
                          } else {
                            data = [data.length > 0 ? data[0] : 0, int.parse(v)];
                          }

                          switch (p.value) {
                            case "meter":
                              filters.mater = data;
                              break;
                            case "price":
                              filters.price = data;
                              break;
                            case "rent":
                              filters.rent = data;
                              break;
                            case "prices":
                              filters.prices = data;
                              break;
                            default:
                          }

                          onChangeFilter();
                        },
                        style: TextStyle(
                          fontSize: 13,
                          color: App.theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }

      props = (snapshot.data! as PropertyLoadedState).iproperties;

      props = props.where((element) => element.type == "List").toList();

      props.forEach((prop) {
        widgets.addAll([
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              prop.name ?? '',
              style: TextStyle(
                color: App.isDark ? DarkThemes.textMediumLight : Themes.secondary2,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: prop.items!
                  .map<Widget>(
                    (e) => Padding(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          if (propFilters.containsKey(prop.value) && propFilters[prop.value] == e.value.toString()) {
                            setState(() {
                              propFilters.remove(prop.value);
                            });
                          } else {
                            setState(() {
                              propFilters[prop.value!] = e.value.toString();
                            });
                          }
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 50,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: propFilters.containsKey(prop.value) && propFilters[prop.value] == e.value.toString() ? Themes.secondary2 : Colors.transparent,
                            border: Border.all(color: Themes.secondary2, width: 1),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            e.name ?? "",
                            style: TextStyle(
                              color: propFilters.containsKey(prop.value) && propFilters[prop.value] == e.value.toString() ? Themes.textLight : (App.isDark ? DarkThemes.textMediumLight : Themes.text),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).toList(),
            ),
          ),
        ]);
      });

      if (widgets.isEmpty) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 245,
          ),
        );
      }

      widgets.addAll([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "امکانات تصویری فایل",
            style: TextStyle(
              color: App.isDark ? DarkThemes.textMediumLight : Themes.secondary2,
              fontSize: 13,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _hasImage = !_hasImage;
                      });
                      onChangeFilter();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: _hasImage ? Themes.secondary2 : Colors.transparent,
                        border: Border.all(color: Themes.secondary2, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "عکس دار",
                        style: TextStyle(
                          color: _hasImage ? Themes.textLight : (App.isDark ? DarkThemes.textMediumLight : Themes.text),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _hasVideo = !_hasVideo;
                      });
                      onChangeFilter();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: _hasVideo ? Themes.secondary2 : Colors.transparent,
                        border: Border.all(color: Themes.secondary2, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "ویدیو دار",
                        style: TextStyle(
                          color: _hasVideo ? Themes.textLight : (App.isDark ? DarkThemes.textMediumLight : Themes.text),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _hasTour = !_hasTour;
                      });
                      onChangeFilter();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: _hasTour ? Themes.secondary2 : Colors.transparent,
                        border: Border.all(color: Themes.secondary2, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "تور مجازی",
                        style: TextStyle(
                          color: _hasTour ? Themes.textLight : (App.isDark ? DarkThemes.textMediumLight : Themes.text),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]);

      return SizedBox(
        height: 245,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        ),
      );
    }
    if (snapshot.data is PropertyErrorState) {
      return Expanded(child: TryAgain());
    }
    if (snapshot.data is PropertyLoadingState || snapshot.data is PropertyInitState) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          height: 245,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Loading(
            backgroundColor: Colors.transparent,
          ),
        ),
      );
    }

    return Container(
      height: 160,
    );
  }

  void setMainCat(Category? mainCategory) {
    setState(() {
      _mainCategory = mainCategory;

      filters = Filters();

      if (_mainCategory == null) {
        _subCategory = null;

        propertyBloc.add(PropertyInsertEvent(category_id: null, type: "filter"));
      }

      var data = categories.where((element) => element.parentId == _mainCategory?.id! && _mainCategory != null).toList();

      data.sort((a, b) => a.isAllInt().compareTo(b.isAllInt()));

      data = data.toList();

      subCategories.add(data);

      _subCategory = data.firstWhere((element) => element.isAll ?? false);

      propertyBloc.add(PropertyInsertEvent(category_id: _subCategory!.id!, type: "filter"));
    });
  }

  void _onTapSubmit() {
    if (filters.mater != null && filters.mater!.length == 2) {
      if (filters.mater![0] > filters.mater![1]) {
        return notify("حداقل متراژ از حداکثر متراژ بیشتر است");
      }
    }

    if (filters.price != null && filters.price!.length == 2) {
      if (filters.price![0] > filters.price![1]) {
        return notify("حداقل ودیعه از حداکثر ودیعه بیشتر است");
      }
    }

    if (filters.rent != null && filters.rent!.length == 2) {
      if (filters.rent![0] > filters.rent![1]) {
        return notify("حداقل اجاره از حداکثر متراژ اجاره است");
      }
    }

    if (filters.prices != null && filters.prices!.length == 2) {
      if (filters.prices![0] > filters.prices![1]) {
        return notify("حداقل قیمت کل از حداکثر قیمت کل بیشتر است");
      }
    }

    if (filters.prices?.length == 1) {
      filters.prices = [
        filters.prices![0],
        99999999999999999,
      ];
    }

    if (filters.price?.length == 1) {
      filters.price = [
        filters.price![0],
        99999999999999999,
      ];
    }

    if (filters.rent?.length == 1) {
      filters.rent = [
        filters.rent![0],
        99999999999999999,
      ];
    }

    if (filters.mater?.length == 1) {
      filters.mater = [
        filters.mater![0],
        99999999999999999,
      ];
    }

    widget.filterData.filters = filters;
    widget.filterData.mainCategory = _mainCategory;
    widget.filterData.category = _subCategory;
    widget.filterData.hasImage = _hasImage;
    widget.filterData.hasVideo = _hasVideo;
    widget.filterData.hasTour = _hasTour;
    widget.filterData.propFilters = propFilters;

    Navigator.pop(
      context,
      widget.filterData,
    );
  }

  Widget _buildTotalFileBloc(BuildContext context, TotalFileState state) {
    if (state is TotalFileInitState) return Container();

    if (state is TotalFileLoadingState)
      return Padding(
        padding: EdgeInsets.only(right: 5),
        child: SpinKitWave(
          size: 14,
          color: Themes.iconLight,
        ),
      );

    if (state is TotalFileErrorState) return Container();

    if (state is TotalFileLoadedState)
      return Padding(
        padding: EdgeInsets.only(right: 5),
        child: TextNormalLight(
          "(${state.totalCount})",
        ),
      );

    return Container();
  }

  onChangeFilter() {
    if (widget.total_url == null) return;

    var filterData = widget.filterData;
    filterData.filters = filters;
    filterData.mainCategory = _mainCategory;
    filterData.category = _subCategory;
    filterData.hasImage = _hasImage;
    filterData.hasVideo = _hasVideo;
    filterData.hasTour = _hasTour;
    filterData.propFilters = propFilters;

    if (filterData.filters?.prices?.length == 1) {
      filterData.filters!.prices = [
        filterData.filters!.prices![0],
        99999999999999999,
      ];
    }

    if (filterData.filters?.price?.length == 1) {
      filterData.filters!.price = [
        filterData.filters!.price![0],
        99999999999999999,
      ];
    }

    if (filterData.filters?.rent?.length == 1) {
      filterData.filters!.rent = [
        filterData.filters!.rent![0],
        99999999999999999,
      ];
    }

    if (filterData.filters?.mater?.length == 1) {
      filterData.filters!.mater = [
        filterData.filters!.mater![0],
        99999999999999999,
      ];
    }

    totalFileBloc.add(TotalFileGetEvent(filterData: filterData));

    var conditions = <bool>[
      filterData.mainCategory != null && filterData.category != null,
      filterData.hasImage ?? false,
      filterData.hasVideo ?? false,
      filterData.hasTour ?? false,
      filterData.filters?.mater?.isFill() ?? false,
      filterData.filters?.price?.isFill() ?? false,
      filterData.filters?.prices?.isFill() ?? false,
      filterData.filters?.rent?.isFill() ?? false,
    ];

    setState(() {
      totalFilters = conditions.where((element) => element).length;
    });
  }
}
