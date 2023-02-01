import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/categories_bloc.dart';
import 'package:siraf3/bloc/property_bloc.dart';
import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/models/property_insert.dart';
import 'package:siraf3/money_input_formatter.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';

class FilterScreen extends StatefulWidget {
  FilterData originalFilterData;
  FilterData filterData;

  FilterScreen(
      {required this.originalFilterData, required this.filterData, super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  CategoriesBloc categoriesBloc = CategoriesBloc();
  PropertyBloc propertyBloc = PropertyBloc();

  StreamController<List<Category>> subCategories = StreamController();

  bool _hasImage = false;
  bool _hasVideo = false;
  bool _hasTour = false;

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();

    categoriesBloc.add(CategoriesFetchEvent());
    categoriesBloc.stream.listen((event) {
      if (event is CategoriesBlocLoaded) {
        categories = event.categories;

        setMainCat(event.categories
            .where((element) => element.parentId == null)
            .first);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => categoriesBloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<CategoriesBloc, CategoriesBlocState>(
            builder: _buildMainWidgets),
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
      child: Stack(
        children: [
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
                              style: TextStyle(
                                  color: Themes.textLight, fontSize: 16),
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

                            propertyBloc.add(PropertyInsertEvent(
                                category_id: null, type: "filter"));

                            filters = Filters();
                            _hasImage = false;
                            _hasVideo = false;
                            _hasTour = false;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            "حذف همه",
                            style: TextStyle(
                                color: Themes.textLight, fontSize: 13),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(-1, 0),
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                offset: Offset(1, 0),
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                offset: Offset(0, 0),
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                offset: Offset(1, 1),
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
                                offset: Offset(-1, -1),
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ]),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: categories
                                .where((element) => element.parentId == null)
                                .map<Widget>(
                                    (e) => _mainCategoryItem(categories, e))
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // if (_mainCategory != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-1, 0),
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              offset: Offset(1, 0),
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              offset: Offset(0, 0),
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              offset: Offset(1, 1),
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              offset: Offset(-1, -1),
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: StreamBuilder(
                                builder: ((context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null &&
                                      (snapshot.data as List<Category>)
                                          .isNotEmpty) {
                                    var items = (snapshot.data
                                            as List<Category>)
                                        .map<Widget>((e) => _subCategoryItem(e))
                                        .toList();
                                    return Row(
                                      // scrollDirection: Axis.horizontal,
                                      children: items.take(4).toList(),
                                    );
                                  }
                                  return Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _subCategory = null;
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                "همه",
                                                style: TextStyle(
                                                  color: Themes.secondary2,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Divider(
                                                color: _subCategory == null
                                                    ? Themes.primary
                                                    : Themes.secondary2,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                stream: subCategories.stream,
                              ),
                            ),
                            StreamBuilder(
                              builder: _buildFields,
                              stream: propertyBloc.stream,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "امکانات تصویری فایل",
                                style: TextStyle(
                                  color: Themes.secondary2,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: _hasImage
                                                ? Themes.secondary2
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: Themes.secondary2,
                                                width: 1),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "عکس دار",
                                            style: TextStyle(
                                              color: _hasImage
                                                  ? Themes.textLight
                                                  : Themes.text,
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
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: _hasVideo
                                                ? Themes.secondary2
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: Themes.secondary2,
                                                width: 1),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "ویدیو دار",
                                            style: TextStyle(
                                              color: _hasVideo
                                                  ? Themes.textLight
                                                  : Themes.text,
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
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: _hasTour
                                                ? Themes.secondary2
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: Themes.secondary2,
                                                width: 1),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "تور مجازی",
                                            style: TextStyle(
                                              color: _hasTour
                                                  ? Themes.textLight
                                                  : Themes.text,
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
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.filterData.filters = filters;
                                widget.filterData.categoryId = _subCategory?.id;
                                widget.filterData.hasImage = _hasImage;
                                widget.filterData.hasVideo = _hasVideo;
                                widget.filterData.hasTour = _hasTour;

                                Navigator.pop(
                                  context,
                                  widget.filterData,
                                );
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Themes.primary,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "اعمال فیلتر",
                                  style: TextStyle(
                                    color: Themes.textLight,
                                    fontSize: 14,
                                  ),
                                ),
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
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: _mainCategory == e ? Themes.primary : Colors.transparent,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 12,
            ),
            alignment: Alignment.center,
            child: Text(
              e.name!,
              style: TextStyle(
                color: _mainCategory == e ? Themes.textLight : Themes.text,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Category? _subCategory;

  _subCategoryItem(Category e) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _subCategory = e;
          });

          propertyBloc.add(PropertyInsertEvent(
              category_id: _subCategory!.id!, type: "filter"));
        },
        child: Column(
          children: [
            Text(
              e.name!,
              style: TextStyle(
                color: Themes.secondary2,
                fontSize: 13,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: _subCategory == e ? Themes.primary : Themes.secondary2,
              height: 1,
            ),
          ],
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

  Widget _buildFields(
      BuildContext context, AsyncSnapshot<PropertyState> snapshot) {
    if (!snapshot.hasData || snapshot.data is PropertyInitState) {
      return Container();
    }

    if (snapshot.data is PropertyLoadedState) {
      var props = (snapshot.data! as PropertyLoadedState).iproperties;

      props = props
          .where((element) => numberFieldsText.any((e) => e == element.value))
          .toList();

      props.sort((a, b) => numberFieldsText
          .indexOf(a.value!)
          .compareTo(numberFieldsText.indexOf(b.value!)));

      filters = filters;

      var widgets = <Widget>[];

      for (PropertyInsert p in props) {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.name!,
                style: TextStyle(
                  color: Themes.secondary2,
                  fontSize: 13,
                ),
              ),
              SizedBox(width: 3),
              if (p.isPrice())
                Text(
                  "(تومان)",
                  style: TextStyle(
                    color: Themes.secondary2,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ));

        widgets.add(Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField2(
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
                    },
                    style: TextStyle(
                      fontSize: 13,
                      color: Themes.text,
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
                  child: TextField2(
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
                        data = [data.length > 1 ? data[1] : 0, int.parse(v)];
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
                    },
                    style: TextStyle(
                      fontSize: 13,
                      color: Themes.text,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    }
    if (snapshot.data is PropertyErrorState) {
      return Expanded(child: TryAgain());
    }
    if (snapshot.data is PropertyLoadingState) {
      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Loading(
            backgroundColor: Colors.transparent,
          ),
        ),
      );
    }

    return Container();
  }

  void setMainCat(Category? mainCategory) {
    setState(() {
      _mainCategory = mainCategory;

      if (_mainCategory == null) {
        _subCategory = null;

        propertyBloc
            .add(PropertyInsertEvent(category_id: null, type: "filter"));
      }

      var data = categories
          .where((element) =>
              element.parentId == _mainCategory?.id! && _mainCategory != null)
          .toList();

      data.sort((a, b) => a.isAllInt().compareTo(b.isAllInt()));

      data = data.toList();

      subCategories.add(data);

      _subCategory = data.firstWhere((element) => element.isAll ?? false);

      propertyBloc.add(
          PropertyInsertEvent(category_id: _subCategory!.id!, type: "filter"));
    });
  }
}
