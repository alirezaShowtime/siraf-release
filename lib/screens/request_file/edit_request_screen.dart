import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:siraf3/bloc/edit_file_request_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/category.dart';
import 'package:siraf3/models/city.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/models/request.dart';
import 'package:siraf3/money_input_formatter.dart';
import 'package:siraf3/screens/create/estate_screen.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/screens/request_file/request_list_screen.dart';
import 'package:siraf3/screens/select_category_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/block_btn.dart';
import 'package:siraf3/widgets/my_app_bar.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/text_field_2.dart';

import '../../../widgets/section.dart';

class EditRequestScreen extends StatefulWidget {
  Request request;
  EditRequestScreen({required this.request});

  @override
  State<StatefulWidget> createState() => _EditRequestScreen();
}

class _EditRequestScreen extends State<EditRequestScreen> {
  Category? category;
  City? city;

  List<Category> categories = [];
  List<Estate> selectedEstates = [];

  int? minPrice;
  int? maxPrice;
  int? minMeter;
  int? maxMeter;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  EditRequestFileBloc bloc = EditRequestFileBloc();

  @override
  void initState() {
    super.initState();

    bloc.stream.listen(listen);

    setData();
  }

  setData() {
    if (widget.request.categoryId != null) {
      category = Category.fromJson(widget.request.categoryId!.toJson());
      categories.add(category!);
    }

    if (widget.request.city != null) {
      city = widget.request.city;
      city?.id = widget.request.cityId;
    }

    if (widget.request.minMeter != null) minMeter = widget.request.minMeter;

    if (widget.request.maxMeter != null) maxMeter = widget.request.maxMeter;

    if (widget.request.minPrice != null) minPrice = widget.request.minPrice;

    if (widget.request.maxPrice != null) maxPrice = widget.request.maxPrice;

    if (widget.request.title != null)
      _titleController.text = widget.request.title!;

    if (widget.request.description != null)
      _descriptionController.text = widget.request.description!;

    if (widget.request.estates != null)
      selectedEstates = widget.request.estates!;

    setState(() {});
  }

  BuildContext? buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      backgroundColor: Themes.background,
      appBar: MyAppBar(
        backgroundColor: Themes.appBar,
        leading: MyBackButton(),
        title: AppBarTitle("ویرایش درخواست"),
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
                SizedBox(height: 20),
                Text(
                  "مشخصات کلی",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "IranSansBold",
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
                        hintStyle: TextStyle(fontSize: 13),
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
                          color: Themes.textGrey,
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
                      hintStyle: TextStyle(fontSize: 13),
                    ),
                    controller: _descriptionController,
                    cursorColor: Themes.primary,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Section(
                  title: "دفتر/دفاتر املاک(اختیاری)",
                  hint: "انتخاب",
                  value: selectedEstates.isNotEmpty
                      ? "${selectedEstates.length} مورد"
                      : null,
                  onTap: onClickSelectEstate,
                ),
                SizedBox(height: 10),
                Text(
                  'این درخواست فقط برای دفتر شما ثبت خواهد شد',
                  style: TextStyle(
                    color: Themes.text,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BlockBtn(onTap: _submit, text: "ثبت درخواست"),
          ),
        ],
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

  Widget textButton(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontFamily: "IranSansBold",
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

  BuildContext? resetDialogContext;

  showResetDialog() {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        resetDialogContext = _;
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Themes.background,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
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
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: dismissResetDialog,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 50,
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
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 50,
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

  BuildContext? numberPhoneDialog;

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Themes.background,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
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
                      height: 50,
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
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              color: Themes.primary,
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

    bloc.add(EditRequestFileEvent(
      request_id: widget.request.id!,
      category_id: category!.id!,
      city_id: city!.id!,
      minPrice: minPrice ?? 0,
      maxPrice: maxPrice ?? 0,
      minMeter: minMeter ?? 0,
      maxMeter: maxMeter ?? 0,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      estateIds: selectedEstates.map((e) => e.id!).toList(),
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

  listen(EditRequestFileState event) {
    if (event is EditRequestFileLoadingState) {
      loadingDialog(context: context);
    }
    if (event is EditRequestFileErrorState) {
      String? message;

      if (event.response != null) {
        try {
          message = jDecode(event.response!.body)['message'];
        } on Exception catch (_) {}
      }

      dismissDialog(loadingDialogContext);

      errorDialog(
        context: context,
        message: message,
      );
    }
    if (event is EditRequestFileSuccessState) {
      dismissDialog(loadingDialogContext);
      notify("درخواست فایل با موفقیت ثبت شد");

      pushReplacement(
        context,
        HomeScreen(
          nextScreen: MaterialPageRoute(
            builder: (_) => RequestListScreen(),
          ),
        ),
      );
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
