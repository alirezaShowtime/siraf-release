import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:siraf3/bloc/add_file_request_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/money_input_formatter.dart';
import 'package:siraf3/screens/create/estate_screen.dart';
import 'package:siraf3/screens/request_file/request_list_screen.dart';
import 'package:siraf3/screens/select_category_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/screens/send_request_guide.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:flutter/material.dart';
import '../../widgets/section.dart';
import 'package:siraf3/dialog.dart';

class RequestFileScreen extends StatefulWidget {
  List<Estate> estates;

  RequestFileScreen({this.estates = const []});

  @override
  State<StatefulWidget> createState() => _RequestFileScreen();
}

class _RequestFileScreen extends State<RequestFileScreen> {
  Category? category;
  City? city;

  List<Estate> selectedEstates = [];

  List<Category> categories = [];

  int? minPrice;
  int? maxPrice;
  int? minMeter;
  int? maxMeter;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  AddFileRequestBloc bloc = AddFileRequestBloc();

  @override
  void initState() {
    super.initState();

    bloc.stream.listen(listen);

    setEstates();
  }

  setEstates() {
    selectedEstates = widget.estates;
  }

  BuildContext? buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      backgroundColor: Themes.background,
      appBar: AppBar(
        backgroundColor: Themes.appBar,
        leading: MyBackButton(),
        title: AppBarTitle("درخواست فایل"),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        elevation: 0.7,
        actions: [
          IconButton(
            onPressed: showResetDialog,
            icon: icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Themes.textGrey.withOpacity(0.5), width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "راهنما",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "IranSansMedium",
                          color: Themes.text,
                        ),
                      ),
                      GestureDetector(
                        onTap: onClickGuideItem,
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 30,
                          ),
                          color: Colors.transparent,
                          alignment: Alignment.centerLeft,
                          child: icon(Icons.chevron_right_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "مشخصات کلی",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Themes.blue,
                  ),
                ),
                Section(
                  title: "دسته بندی",
                  hint: "انتخاب",
                  value: category != null
                      ? categories.map((e) => e.name).join(' > ')
                      : null,
                  onTap: onClickCategoryItem,
                ),
                Section(
                  title: "شهر",
                  hint: "انتخاب",
                  value: city?.name,
                  onTap: onClickCityItem,
                ),
                Section(
                  title: "محدوده متراژ",
                  hint: "تعیین",
                  value: createLabel(minMeter, maxMeter, 'متر'),
                  onTap: onClickMeterageItem,
                ),
                Section(
                  title: "محدوده قیمت",
                  hint: "تعیین",
                  value: createLabel(minPrice, maxPrice, 'تومان'),
                  onTap: onClickPriceItem,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 20),
                  child: SizedBox(
                    height: 45,
                    child: TextField2(
                      decoration: InputDecoration(
                        labelText: 'عنوان',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Themes.icon,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Themes.primary,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Themes.textGrey,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        hintText:
                            "در این قسمت به موارد مهم ملک مانند نوع ملک و محله اشاره کنید",
                        hintStyle: TextStyle(fontSize: 14),
                        labelStyle: TextStyle(fontSize: 14),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        floatingLabelStyle: TextStyle(color: Themes.primary),
                      ),
                      controller: _titleController,
                      style: TextStyle(fontSize: 14),
                      maxLines: 1,
                      cursorColor: Themes.primary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextField2(
                    textAlignVertical: TextAlignVertical.top,
                    maxLines: 8,
                    decoration: InputDecoration(
                      labelText: 'توضیحات',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Themes.icon,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Themes.primary,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Themes.textGrey,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      floatingLabelStyle: TextStyle(color: Themes.primary),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(fontSize: 14),
                      hintText:
                          "در این قسمت به جزئیات ملک مانند امکانات ، ویژگی ها و ... که برای شمااهمیت دارد اشاره کنید",
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                    controller: _descriptionController,
                    cursorColor: Themes.primary,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Section(
                  title: "دفتر/دفاتر املاک(اخیتاری)",
                  hint: "انتخاب",
                  value: selectedEstates.isNotEmpty
                      ? "${selectedEstates.length} مورد"
                      : null,
                  onTap: onClickSelectEstate,
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: _submit,
                      color: Themes.primary,
                      child: Text(
                        "ثبت درخواست",
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textButton(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: Themes.blue,
      ),
    );
  }

  void onClickCategoryItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategorySelectScreen(filterIsAllCategories: true),
      ),
    ).then((result) {
      if (result != null || result is List<Category>) {
        setState(() {
          categories = result;
          category = result.last;
        });
      }
    });
  }

  void onClickCityItem() async {
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

  void onClickMeterageItem() {
    showNumberDialog(
      minMeter != null ? minMeter.toString() : "",
      maxMeter != null ? maxMeter.toString() : "",
      "متراژ به متر",
      "متر",
      (p0, p1) {
        setState(() {
          if (p0.isEmpty) {
            minMeter = null;
          }
          if (p1.isEmpty) {
            maxMeter = null;
          }
          var minOk = (p0.isNotEmpty && isNumeric(p0.replaceAll(',', '')));
          var maxOk = (p1.isNotEmpty && isNumeric(p1.replaceAll(',', '')));
          if (minOk && maxOk) {
            var min = int.parse(p0.replaceAll(',', ''));
            var max = int.parse(p1.replaceAll(',', ''));

            if (min >= max) {
              return notify("مقدار حداقل متراژ باید کمتر از حداکثر باشد");
            }
          }
          if (p0.isNotEmpty && isNumeric(p0.replaceAll(',', ''))) {
            minMeter = int.parse(p0.replaceAll(',', ''));
          }
          if (p1.isNotEmpty && isNumeric(p1.replaceAll(',', ''))) {
            maxMeter = int.parse(p1.replaceAll(',', ''));
          }
          dismissNumberDialog();
        });
      },
    );
  }

  void onClickPriceItem() {
    showNumberDialog(
      minPrice != null ? minPrice.toString() : "",
      maxPrice != null ? maxPrice.toString() : "",
      "قیمت به تومان",
      "تومان",
      (p0, p1) {
        setState(() {
          if (p0.isEmpty) {
            minPrice = null;
          }
          if (p1.isEmpty) {
            maxPrice = null;
          }
          var minOk = (p0.isNotEmpty && isNumeric(p0.replaceAll(',', '')));
          var maxOk = (p1.isNotEmpty && isNumeric(p1.replaceAll(',', '')));
          if (minOk && maxOk) {
            var min = int.parse(p0.replaceAll(',', ''));
            var max = int.parse(p1.replaceAll(',', ''));

            if (min >= max) {
              return notify("مقدار حداقل قیمت باید کمتر از حداکثر باشد");
            }
          }
          if (minOk) {
            minPrice = int.parse(p0.replaceAll(',', ''));
          }
          if (maxOk) {
            maxPrice = int.parse(p1.replaceAll(',', ''));
          }

          dismissNumberDialog();
        });
      },
    );
  }

  void onClickGuideItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SendRequestGuide(),
      ),
    );
  }

  void onClickSelectEstate() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EstateScreen(
          estates: selectedEstates,
        ),
      ),
    );
    if (result is List<Estate>) {
      setState(() {
        selectedEstates = result;
      });
    }
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
                        'آیا مایل به ثبت درخواست از ابتدا هستید؟',
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

  BuildContext? numberDialog;

  showNumberDialog(String minVal, String maxVal, String label, String labelP,
      void Function(String, String) onTap) {
    StreamController<String> persianNumberTextMin = StreamController();
    persianNumberTextMin.add(minVal.replaceAll(',', '').toWord());

    StreamController<String> persianNumberTextMax = StreamController();
    persianNumberTextMax.add(maxVal.replaceAll(',', '').toWord());

    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        numberDialog = _;

        TextEditingController _minController = TextEditingController(
          text: minVal.isNotEmpty ? number_format(int.parse(minVal)) : "",
        );

        TextEditingController _maxController = TextEditingController(
          text: maxVal.isNotEmpty ? number_format(int.parse(maxVal)) : "",
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
                          controller: _minController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "حداقل ${label}",
                            hintStyle: TextStyle(
                              color: Themes.textGrey,
                              fontSize: 13,
                              fontFamily: "IranSans",
                            ),
                          ),
                          onChanged: (v) {
                            persianNumberTextMin.add(v.toWord());
                          },
                          inputFormatters: [
                            MoneyInputFormatter(mantissaLength: 0),
                          ],
                          textInputAction: TextInputAction.next,
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
                    StreamBuilder(
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data.toString().isEmpty) {
                          return Container(
                            alignment: Alignment.center,
                            height: 20,
                            child: Text(
                              "",
                              style: TextStyle(
                                color: Themes.text,
                                fontSize: 11,
                                fontFamily: "IranSansMedium",
                              ),
                            ),
                          );
                        }
                        String text = snapshot.data.toString() + " " + labelP;

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
                      stream: persianNumberTextMin.stream,
                    ),
                    SizedBox(height: 3),
                    Divider(height: 1, color: Themes.textGrey.withOpacity(0.5)),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        child: TextField2(
                          maxLines: 1,
                          controller: _maxController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "حداکثر ${label}",
                            hintStyle: TextStyle(
                              color: Themes.textGrey,
                              fontSize: 13,
                              fontFamily: "IranSans",
                            ),
                          ),
                          onChanged: (v) {
                            persianNumberTextMax.add(v.toWord());
                          },
                          inputFormatters: [
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
                    StreamBuilder(
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data.toString().isEmpty) {
                          return Container(
                            alignment: Alignment.center,
                            height: 20,
                            child: Text(
                              "",
                              style: TextStyle(
                                color: Themes.text,
                                fontSize: 11,
                                fontFamily: "IranSansMedium",
                              ),
                            ),
                          );
                        }
                        String text = snapshot.data.toString() + " " + labelP;

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
                      stream: persianNumberTextMax.stream,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                onTap(_minController.text, _maxController.text);
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

  _resetData() {
    setState(() {
      categories = [];
      category = null;
      city = null;
      selectedEstates = [];

      minPrice = null;
      maxPrice = null;
      minMeter = null;
      maxMeter = null;

      _titleController.clear();
      _descriptionController.clear();
    });
  }

  void _submit() {
    if (!validate()) {
      return;
    }

    bloc.add(AddFileRequestEvent(
      category_id: category!.id!,
      city_id: city!.id!,
      minPrice: minPrice ?? 0,
      maxPrice: maxPrice ?? 0,
      minMeter: minMeter ?? 0,
      maxMeter: maxMeter ?? 0,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      estates: selectedEstates.isEmpty ? null : selectedEstates,
    ));
  }

  String? createLabel(int? min, int? max, String label) {
    if (min == null && max == null) {
      return null;
    }

    String text = "";

    if (min != 0 && min != null) {
      text += "از " + number_format(min);
    } else if (min != null) {
      text += "از صفر";
    }

    if (max != 0 && max != null) {
      text += " تا " + number_format(max);
    }

    return "${text} ${label}";
  }

  listen(AddFileRequestState event) {
    if (event is AddFileRequestLoadingState) {
      loadingDialog(context: context);
    }
    if (event is AddFileRequestErrorState) {
      String? message;

      if (event.response != null) {
        try {
          message = jDecode(event.response!.body)['message'];
        } on Exception catch (_) {}
      }

      errorDialog(
        context: context,
        message: message,
      );
    }
    if (event is AddFileRequestSuccessState) {
      print(convertUtf8(event.response.body));
      dismissDialog(loadingDialogContext);
      notify("درخواست فایل با موفقیت ثبت شد");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => RequestListScreen()));
    }
  }

  bool validate() {
    if (category == null) {
      notify("لطفا دسته بندی را انتخاب کنید");
      return false;
    }

    if (city == null) {
      notify("لطفا شهر را انتخاب کنید");
      return false;
    }

    if (minMeter == null && maxMeter == null) {
      notify("لطفا محدوده متراژ را مشخص کنید");
      return false;
    }

    if (minPrice == null && maxPrice == null) {
      notify("لطفا محدوده قیمت را مشخص کنید");
      return false;
    }

    if (_titleController.text.trim().isEmpty) {
      notify("لطفا عنوان را وارد کنید");
      return false;
    }

    if (_descriptionController.text.trim().isEmpty) {
      notify("لطفا توضیحات را وارد کنید");
      return false;
    }
    return true;
  }
}
