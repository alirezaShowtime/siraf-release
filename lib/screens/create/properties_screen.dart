import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/property_insert.dart';
import 'package:siraf3/themes.dart';

import '../../money_input_formatter.dart';
import '../../widgets/text_field_2.dart';

class PropertiesScreen extends StatefulWidget {
  List<PropertyInsert> properties;
  List<PropertyInsert> features;
  Category category;
  Map<String, dynamic> selectedProps;
  Map<String, dynamic> selectedFeatures;

  PropertiesScreen({
    super.key,
    required this.properties,
    required this.features,
    required this.category,
    required this.selectedProps,
    required this.selectedFeatures,
  });

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  Map<String, dynamic> selectedProps = {};
  Map<String, dynamic> selectedFeatures = {};

  Map<String, String> hints = {
    "meter": "متراژ را به متر وارد کنید",
    "price": "قیمت کل را به تومان وارد کنید",
    "age": "سال ساخت را وارد کنید",
    "prices": "مبلغ ودیعه را به تومان وارد کنید",
    "rent": "مبلغ اجاره را به تومان وارد کنید",
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

  @override
  void initState() {
    super.initState();

    setProps();
  }

  setProps() {
    setState(() {
      selectedProps = widget.selectedProps;
      selectedFeatures = widget.selectedFeatures;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, [selectedProps, selectedFeatures]);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "انتخاب سایر ویژگی ها و امکانات",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, [selectedProps, selectedFeatures]);
            },
            icon: Icon(
              CupertinoIcons.back,
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
                          if (widget.properties.isNotEmpty)
                            SizedBox(
                              height: 20,
                            ),
                          if (widget.properties.isNotEmpty)
                            Text(
                              "سایر ویژگی ها",
                              style: TextStyle(
                                fontSize: 15,
                                color: App.theme.primaryColor,
                                fontFamily: "IranSansBold",
                              ),
                            ),
                          if (widget.properties.isNotEmpty) SizedBox(height: 14),
                        ] +
                        widget.properties.map<Widget>((e) {
                          String? text;
                          if (selectedProps.containsKey(e.value!)) {
                            if (e.type!.toLowerCase() == "number") {
                              text = selectedProps[e.value!] as String;

                              if (priceFields.contains(e.value!)) {
                                text += " تومان";
                              }

                              if (e.value == "prices") {
                                text = "ودیعه :  " + text;
                              } else if (e.value == "rent") {
                                if (widget.category.name!.contains("روز")) {
                                  text = "اجاره روزانه : " + text;
                                } else {
                                  text = "اجاره : " + text;
                                }
                              } else if (e.value == "age") {
                                text = "سال " + text;
                              } else if (e.value == "meter") {
                                text += " متر";
                              }
                            } else {
                              var properties = widget.properties.where((element) =>
                                  element.value == e.value &&
                                  (element.items ?? [])
                                      .where(
                                        (element) => element.value.toString() == selectedProps[e.value!],
                                      )
                                      .isNotEmpty);
                              if (properties.isNotEmpty) {
                                var item = properties.first.items!.firstWhere((element) => element.value.toString() == selectedProps[e.value!]);
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
                        [
                          if (widget.features.isNotEmpty)
                            SizedBox(
                              height: 20,
                            ),
                          if (widget.features.isNotEmpty)
                            Text(
                              "سایر امکانات",
                              style: TextStyle(
                                fontSize: 15,
                                color: App.theme.primaryColor,
                                fontFamily: "IranSansBold",
                              ),
                            ),
                          if (widget.features.isNotEmpty)
                            SizedBox(
                              height: 14,
                            ),
                        ] +
                        widget.features.map<Widget>((e) {
                          String? text;
                          if (selectedFeatures.containsKey(e.value!)) {
                            if (e.type!.toLowerCase() == "number") {
                              text = selectedFeatures[e.value!] as String;

                              if (priceFields.contains(e.value!)) {
                                text += " تومان";
                              }

                              if (e.value == "prices") {
                                text = "ودیعه :  " + text;
                              } else if (e.value == "rent") {
                                if (widget.category.name!.contains("روز")) {
                                  text = "اجاره روزانه : " + text;
                                } else {
                                  text = "اجاره : " + text;
                                }
                              } else if (e.value == "age") {
                                text = "سال " + text;
                              } else if (e.value == "meter") {
                                text += " متر";
                              }
                            } else {
                              var properties = widget.features.where((element) =>
                                  element.value == e.value &&
                                  (element.items ?? [])
                                      .where(
                                        (element) => element.value.toString() == selectedFeatures[e.value!],
                                      )
                                      .isNotEmpty);
                              if (properties.isNotEmpty) {
                                var item = properties.first.items!.firstWhere((element) => element.value.toString() == selectedFeatures[e.value!]);
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
                        }).toList(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        for (PropertyInsert pr in widget.properties) {
                          if ((pr.require ?? false) && !selectedProps.containsKey(pr.value!)) {
                            return notify("لطفا " + pr.name! + " را " + (pr.type!.toLowerCase() == "list" ? "انتخاب" : "تعیین") + " کنید");
                          }
                        }

                        for (PropertyInsert pr in widget.features) {
                          if ((pr.require ?? false) && !selectedFeatures.containsKey(pr.value!)) {
                            return notify("لطفا " + pr.name! + " را " + (pr.type!.toLowerCase() == "list" ? "انتخاب" : "تعیین") + " کنید");
                          }
                        }
                        Navigator.pop(context, [selectedProps, selectedFeatures]);
                      },
                      color: App.theme.primaryColor,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget section({required String title, required String hint, required String? value, required Function() onTap}) {
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
          color: (App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey).withOpacity(0.5),
          height: 1,
        ),
      ],
    );
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

  BuildContext? numberDialog;

  showNumberDialog(PropertyInsert property) {
    StreamController<String> persianNumberText = StreamController();
    persianNumberText.add(((selectedProps[property.value!] ?? '').replaceAll(',', '') as String).toWord());

    StreamController<String?> value = StreamController();
    value.add(selectedProps[property.value!]);

    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        numberDialog = _;
        TextEditingController _controller = TextEditingController(
          text: selectedProps[property.value!],
        );
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: App.theme.dialogBackgroundColor,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
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
                            hintText: hints.containsKey(property.value) ? hints[property.value] : "${property.name!} را وارد کنید",
                            hintStyle: TextStyle(
                              color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                              fontSize: 13,
                              fontFamily: "IranSans",
                            ),
                          ),
                          onChanged: (v) {
                            persianNumberText.add(v.toWord());
                            value.add(v);
                          },
                          inputFormatters: [
                            if (property.value != "age") MoneyInputFormatter(mantissaLength: 0),
                          ],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: App.theme.textTheme.bodyLarge?.color,
                            fontSize: 13,
                            fontFamily: "IranSansMedium",
                          ),
                        ),
                      ),
                    ),
                    if (helpTexts.containsKey(property.value!))
                      StreamBuilder(
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData || snapshot.data.toString().isEmpty) {
                            return Container(
                              height: 20,
                              alignment: Alignment.center,
                              child: Text(
                                helpTexts[property.value!]!,
                                style: TextStyle(
                                  color: App.theme.textTheme.bodyLarge?.color,
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
                        if (!snapshot.hasData || snapshot.data.toString().isEmpty) {
                          return Container(
                            height: helpTexts.containsKey(property.value!) ? 0 : 20,
                          );
                        }
                        String text = snapshot.data.toString();

                        if (priceFields.contains(property.value!)) {
                          text += " تومان";
                        }

                        if (property.value == "prices") {
                          text = "ودیعه :  " + text;
                        } else if (property.value == "rent") {
                          if (widget.category.name!.contains("روز")) {
                            text = "اجاره روزانه : " + text;
                          } else {
                            text = "اجاره : " + text;
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
                              color: App.theme.textTheme.bodyLarge?.color,
                              fontSize: 11,
                              fontFamily: "IranSansMedium",
                            ),
                          ),
                        );
                      }),
                      stream: persianNumberText.stream,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  if (_controller.text.trim().isNotEmpty) {
                                    selectedProps[property.value!] = _controller.text.trim();
                                  } else {
                                    selectedProps.remove(property.value!);
                                  }
                                });

                                dismissNumberDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              color: App.theme.primaryColor,
                              elevation: 1,
                              height: 50,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: App.theme.dialogBackgroundColor,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Wrap(
              children: [
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: property.items!.map<Widget>((e) => buildListItem(e, property)).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 50,
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
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              color: App.theme.primaryColor,
                              elevation: 1,
                              height: 50,
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
    persianNumberText.add(((selectedProps[property.value!] ?? '').replaceAll(',', '') as String).toWord());

    StreamController<String?> value = StreamController();
    value.add(selectedProps[property.value!]);

    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        numberDialogFeature = _;
        TextEditingController _controller = TextEditingController(
          text: selectedFeatures[property.value!],
        );
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: App.theme.dialogBackgroundColor,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
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
                            hintText: hints.containsKey(property.value) ? hints[property.value] : "${property.name!} را وارد کنید",
                            hintStyle: TextStyle(
                              color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                              fontSize: 13,
                              fontFamily: "IranSans",
                            ),
                          ),
                          onChanged: (v) {
                            persianNumberText.add(v.toWord());
                            value.add(v);
                          },
                          inputFormatters: [
                            if (property.value != "age") MoneyInputFormatter(mantissaLength: 0),
                          ],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: App.theme.textTheme.bodyLarge?.color,
                            fontSize: 13,
                            fontFamily: "IranSansMedium",
                          ),
                        ),
                      ),
                    ),
                    if (helpTexts.containsKey(property.value!))
                      StreamBuilder(
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData || snapshot.data.toString().isEmpty) {
                            return Container(
                              height: 20,
                              alignment: Alignment.center,
                              child: Text(
                                helpTexts[property.value!]!,
                                style: TextStyle(
                                  color: App.theme.textTheme.bodyLarge?.color,
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
                        if (!snapshot.hasData || snapshot.data.toString().isEmpty) {
                          return Container(
                            height: helpTexts.containsKey(property.value!) ? 0 : 20,
                          );
                        }
                        String text = snapshot.data.toString();

                        if (priceFields.contains(property.value!)) {
                          text += " تومان";
                        }

                        if (property.value == "prices") {
                          text = "ودیعه :  " + text;
                        } else if (property.value == "rent") {
                          if (widget.category.name!.contains("روز")) {
                            text = "اجاره روزانه : " + text;
                          } else {
                            text = "اجاره : " + text;
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
                              color: App.theme.textTheme.bodyLarge?.color,
                              fontSize: 11,
                              fontFamily: "IranSansMedium",
                            ),
                          ),
                        );
                      }),
                      stream: persianNumberText.stream,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  if (_controller.text.trim().isNotEmpty) {
                                    selectedFeatures[property.value!] = _controller.text.trim();
                                  } else {
                                    selectedFeatures.remove(property.value!);
                                  }
                                });

                                dismissNumberDialog();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              color: App.theme.primaryColor,
                              elevation: 1,
                              height: 50,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: App.theme.dialogBackgroundColor,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Wrap(
              children: [
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: property.items!.map<Widget>((e) => buildListItem(e, property, isProp: false)).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 50,
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
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              color: App.theme.primaryColor,
                              elevation: 1,
                              height: 50,
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
      color = (selectedProps.containsKey(property.value!) && selectedProps[property.value!] == e.value.toString()) ? Themes.secondary : App.theme.textTheme.bodyLarge?.color;
    } else {
      color = (selectedFeatures.containsKey(property.value!) && selectedFeatures[property.value!] == e.value.toString()) ? Themes.secondary : App.theme.textTheme.bodyLarge?.color;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isProp) {
            selectedProps[property.value!] = e.value.toString();
          } else {
            selectedFeatures[property.value!] = e.value.toString();
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
                    color: (App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey).withOpacity(0.5),
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
