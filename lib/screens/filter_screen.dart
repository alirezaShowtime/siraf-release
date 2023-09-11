import 'dart:async';

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
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/text_form_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';

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

    SystemChrome.setSystemUIOverlayStyle(App.getSystemUiOverlayTransparentLight());

    propFilters = widget.filterData.propFilters ?? {};

    if (widget.total_url != null) totalFileBloc = TotalFileBloc(url: widget.total_url!);

    categoriesBloc.add(CategoriesFetchEvent());
    categoriesBloc.stream.listen((event) {
      if (event is CategoriesBlocLoaded) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: App.isDark ? Color(0xff2d2e33) : Color(0xff534e4f),
            systemNavigationBarDividerColor: App.isDark ? Color(0xff2d2e33) : Color(0xff534e4f),
            systemNavigationBarIconBrightness: Brightness.light,
            systemStatusBarContrastEnforced: false,
          ),
        );
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
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocBuilder<CategoriesBloc, CategoriesBlocState>(builder: _buildMainWidgets),
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

  int type = 1;

  Widget _buildMainWidgetWithCategories(List<Category> categories) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Opacity(
            opacity: App.isDark ? 0.3 : 1,
            child: Image(
              image: AssetImage("assets/images/filter_background.png"),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
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
                          MyBackButton(color: Colors.white, shadow: true),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              right: 5,
                              bottom: 10,
                            ),
                            child: AppBarTitle("فیلتر", color: Colors.white),
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
                            style: TextStyle(
                              color: Themes.textLight,
                              fontSize: 12,
                              fontFamily: "IranSansBold",
                            ),
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
                        decoration: BoxDecoration(
                          color: App.theme.dialogBackgroundColor,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: App.isDark
                              ? []
                              : [
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Row(
                            children: categories.where((element) => element.parentId == null).map<Widget>((e) => _mainCategoryItem(categories, e)).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // if (_mainCategory != null)
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: App.theme.dialogBackgroundColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: App.isDark
                              ? []
                              : [
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
                              margin: EdgeInsets.only(bottom: 10),
                              height: 46,
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: App.isDark ? DarkThemes.textGrey.withOpacity(0.5) : Colors.grey.shade200, width: 1)),
                              ),
                              child: StreamBuilder(
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData && snapshot.data != null && (snapshot.data as List<Category>).isNotEmpty) {
                                    var items = (snapshot.data as List<Category>).map<Widget>((e) => _subCategoryItem(e)).toList();
                                    if (items.length <= 3) {
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: items.map<Widget>((e) => Expanded(child: e)).toList(),
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
                            RawMaterialButton(
                              onPressed: _onTapSubmit,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "اعمال فیلتر",
                                    style: TextStyle(
                                      fontFamily: "IranSansBold",
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  BlocBuilder<TotalFileBloc, TotalFileState>(builder: _buildTotalFileBloc),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                              ),
                              elevation: 0,
                              constraints: BoxConstraints(
                                minHeight: 50,
                                minWidth: double.infinity,
                              ),
                              fillColor: App.theme.primaryColor,
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

  _mainCategoryItem(List<Category> categories, Category category) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 7),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            enableFeedback: _mainCategory?.id != category.id,
            onTap: () {
              setState(() {
                setMainCat(category);
              });

              onChangeFilter();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: _mainCategory?.id == category.id ? App.theme.primaryColor : Colors.transparent,
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: Text(
                category.name!,
                style: TextStyle(
                  color: _mainCategory?.id == category.id ? Themes.textLight : App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                  fontSize: 11,
                  fontFamily: "IranSansBold",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Category? _subCategory;

  _subCategoryItem(Category e) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
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
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 46,
            constraints: BoxConstraints(
              minWidth: (MediaQuery.of(context).size.width - 40) / 4,
            ),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: _subCategory?.id == e.id ? App.theme.primaryColor : Colors.transparent, width: 3)),
            ),
            child: Text(
              e.name ?? "",
              style: TextStyle(
                fontSize: 11,
                fontFamily: _subCategory?.id == e.id ? "IranSansBold" : "IranSansMedium",
                color: _subCategory?.id == e.id ? App.theme.textTheme.bodyLarge?.color ?? Themes.text : (App.isDark ? DarkThemes.textLight : Themes.secondary2),
              ),
            ),
          ),
        ));
  }

  List<String> numberFieldsText = [
    "price",
    "prices",
    "rent",
    "meter",
  ];

  Filters filters = Filters();

  Widget _buildFields(BuildContext context, AsyncSnapshot<PropertyState> snapshot) {
    if (!snapshot.hasData) return Container(height: 160);

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
        var maxInitialValue = data.asMap().containsKey(1) ? (data[1] == 0 ? "" : data[1]) : "";

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
                      fontSize: 11,
                      fontFamily: "IranSansBold",
                    ),
                  ),
                  SizedBox(width: 3),
                  if (p.isPrice())
                    Text(
                      "(تومان)",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 9,
                        fontFamily: "IranSansMedium",
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField2(
                        initialValue: minInitialValue.toString(),
                        inputFormatters: [MoneyInputFormatter(mantissaLength: 0)],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 13, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text, fontFamily: "IranSansBold"),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(color: (App.theme.dividerColor).withOpacity(0.5), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(color: (App.theme.dividerColor).withOpacity(0.5), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(color: App.theme.primaryColor, width: 2),
                          ),
                          hintText: "حداقل",
                          hintStyle: TextStyle(fontSize: 12, color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey, fontFamily: "IranSansMedium"),
                          contentPadding: EdgeInsets.all(10),
                        ),
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
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField2(
                        initialValue: maxInitialValue.toString(),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        inputFormatters: [MoneyInputFormatter(mantissaLength: 0)],
                        style: TextStyle(fontSize: 13, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text, fontFamily: "IranSansBold"),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(color: (App.theme.dividerColor).withOpacity(0.5), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(color: (App.theme.dividerColor).withOpacity(0.5), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45),
                            borderSide: BorderSide(color: App.theme.primaryColor, width: 2),
                          ),
                          hintText: "حداکثر",
                          hintStyle: TextStyle(fontSize: 12, color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey, fontFamily: "IranSansMedium"),
                          contentPadding: EdgeInsets.all(10),
                        ),
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
              style: TextStyle(fontSize: 12, fontFamily: "IranSansBold"),
            ),
          ),
          Container(
            height: 30,
            margin: EdgeInsets.only(bottom: 10, top: 5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(width: 10),
                for (var item in prop.items!)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Material(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: App.theme.dividerColor.withOpacity(0.5), width: 1)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          if (propFilters.containsKey(prop.value) && propFilters[prop.value] == item.value.toString()) {
                            propFilters.remove(prop.value);
                          } else {
                            propFilters[prop.value!] = item.value.toString();
                          }
                          setState(() {});
                          onChangeFilter();
                        },
                        child: Container(
                          constraints: BoxConstraints(minWidth: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: propFilters.containsKey(prop.value) && propFilters[prop.value] == item.value.toString() ? App.theme.primaryColor : Colors.transparent,
                            border: Border.all(color: App.theme.dividerColor.withOpacity(0.5), width: 1),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          alignment: Alignment.center,
                          child: Text(
                            item.name ?? "",
                            style: TextStyle(
                              color: propFilters.containsKey(prop.value) && propFilters[prop.value] == item.value.toString() ? Colors.white : (App.theme.textTheme.bodyLarge?.color),
                              fontSize: 11,
                              fontFamily: "IranSansBold",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ]);
      });

      if (widgets.isEmpty) {
        return Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 160),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "امکانات تصویری فایل",
                  style: TextStyle(fontSize: 12, fontFamily: "IranSansBold"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                              color: _hasImage ? App.theme.primaryColor : Colors.transparent,
                              border: Border.all(color: _hasImage ? App.theme.primaryColor : App.theme.dividerColor.withOpacity(0.9), width: 1),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: Text(
                              "عکس دار",
                              style: TextStyle(
                                color: _hasImage ? Colors.white : App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                                fontFamily: "IranSansBold",
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
                              color: _hasVideo ? App.theme.primaryColor : Colors.transparent,
                              border: Border.all(color: _hasVideo ? App.theme.primaryColor : App.theme.dividerColor.withOpacity(0.9), width: 1),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: Text(
                              "ویدیو دار",
                              style: TextStyle(
                                color: _hasVideo ? Colors.white : App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                                fontFamily: "IranSansBold",
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
                              color: _hasTour ? App.theme.primaryColor : Colors.transparent,
                              border: Border.all(color: _hasTour ? App.theme.primaryColor : App.theme.dividerColor.withOpacity(0.9), width: 1),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: Text(
                              "تور مجازی",
                              style: TextStyle(
                                color: _hasTour ? Colors.white : App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                                fontFamily: "IranSansBold",
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
            ],
          ),
        );
      }

      widgets.addAll([
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "امکانات تصویری فایل",
            style: TextStyle(fontSize: 12, fontFamily: "IranSansBold"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        color: _hasImage ? App.theme.primaryColor : Colors.transparent,
                        border: Border.all(color: _hasImage ? App.theme.primaryColor : Colors.grey.shade300, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: Text(
                        "عکس دار",
                        style: TextStyle(
                          color: _hasImage ? Colors.white : App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          fontSize: 11,
                          fontFamily: "IranSansBold",
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
                        color: _hasVideo ? App.theme.primaryColor : Colors.transparent,
                        border: Border.all(color: _hasVideo ? App.theme.primaryColor : Colors.grey.shade300, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: Text(
                        "ویدیو دار",
                        style: TextStyle(
                          color: _hasVideo ? Colors.white : App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          fontSize: 11,
                          fontFamily: "IranSansBold",
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
                        color: _hasTour ? App.theme.primaryColor : Colors.transparent,
                        border: Border.all(color: _hasTour ? App.theme.primaryColor : Colors.grey.shade300, width: 1),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: Text(
                        "با تور مجازی",
                        style: TextStyle(
                          color: _hasTour ? Colors.white : App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          fontSize: 11,
                          fontFamily: "IranSansBold",
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
          height: 160,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Loading(backgroundColor: Colors.transparent),
        ),
      );
    }

    return Container(height: 160);
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
        child: Text(
          "(${state.totalCount})",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: "IranSansBold",
          ),
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

    if (filterData.filters?.prices?.length == 2 && filterData.filters!.prices![0] == 0 && filterData.filters!.prices![1] == 99999999999999999) {
      filterData.filters!.prices = [];
    } else if (filterData.filters?.prices?.length == 1) {
      filterData.filters!.prices = [
        filterData.filters!.prices![0],
        99999999999999999,
      ];
    }

    if (filterData.filters?.price?.length == 2 && filterData.filters!.price![0] == 0 && filterData.filters!.price![1] == 99999999999999999) {
      filterData.filters!.price = [];
    } else if (filterData.filters?.price?.length == 1) {
      filterData.filters!.price = [
        filterData.filters!.price![0],
        99999999999999999,
      ];
    }

    if (filterData.filters?.rent?.length == 2 && filterData.filters!.rent![0] == 0 && filterData.filters!.rent![1] == 99999999999999999) {
      filterData.filters!.rent = [];
    } else if (filterData.filters?.rent?.length == 1) {
      filterData.filters!.rent = [
        filterData.filters!.rent![0],
        99999999999999999,
      ];
    }

    if (filterData.filters?.mater?.length == 2 && filterData.filters!.mater![0] == 0 && filterData.filters!.mater![1] == 99999999999999999) {
      filterData.filters!.mater = [];
    } else if (filterData.filters?.mater?.length == 1) {
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
      totalFilters = conditions.where((element) => element).length + (filterData.propFilters?.length ?? 0);
    });
  }
}
