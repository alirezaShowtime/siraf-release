import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/models/create_file_form_data.dart';
import 'package:siraf3/screens/create/upload_media_guide.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/text_form_field_2.dart';

class CreateFileSecond extends StatefulWidget {
  CreateFileFormData formData;

  CreateFileSecond({required this.formData, super.key});

  @override
  State<CreateFileSecond> createState() => _CreateFileSecondState();
}

class _CreateFileSecondState extends State<CreateFileSecond> {
  String? title;
  String? description;
  GlobalKey<FormState> formKey = GlobalKey();

  Map<int, String> hints = {
    4: "مثال : آپارتمان 120 متری، میدان ونک",
    5: "مثال : ویالی 1000 متری، لواسان",
    6: "مثال: زمین 300 متری، فرمانیه",
    7: "مثال : دفتر اداری 80 متری، جنت آباد",
    8: "مثال : مغازه 35 متری، میدان ونک",
    9: "زمین کشاورزی 20000 متری، رشت",
    10: "مثال : آپارتمان 120 متری، میدان ونک",
    11: "مثال : ویالی 1000 متری، لواسان",
    12: "مثال: زمین 300 متری، فرمانیه",
    13: "مثال : دفتر اداری 80 متری، جنت آباد",
    14: "مثال : مغازه 35 متری، میدان ونک",
    15: "زمین کشاورزی 20000 متری، رشت",
    16: "مشارکت در ساخت زمین 200 متری، عباس آباد",
    17: "مثال : پیش فروش آپارتمان 135 متری، شهرک غرب",
  };

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
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.back,
            color: Themes.icon,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: _openHelp,
                        child: Container(
                          color: Colors.transparent,
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
                              Icon(
                                CupertinoIcons.right_chevron,
                                color: Themes.text,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Themes.textGrey.withOpacity(0.5),
                        height: 1,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "آپلود فایل های تصویری",
                        style: TextStyle(
                          fontSize: 14,
                          color: Themes.text,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "(عکس، نقشه، ویدیو و تور مجازی)",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontFamily: "IranSansMedium",
                          color: Themes.text,
                        ),
                      ),
                      SizedBox(
                        height: 160,
                      ),
                      Text(
                        "عنوان",
                        style: TextStyle(
                          fontSize: 14,
                          color: Themes.text,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "در عنوان فایل، به موارد مهمی مانند نوع ملک، متراژ و محله اشاره کنید.",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontFamily: "IranSansMedium",
                          color: Themes.text,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField2(
                        decoration: InputDecoration(
                          hintText:
                              hints.containsKey(widget.formData.category.id!)
                                  ? hints[widget.formData.category.id!]
                                  : "مثال : آپارتمان 120 متری، میدان ونک",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Themes.icon,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Themes.primary,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Themes.textGrey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        ),
                        style: TextStyle(fontSize: 14, color: Themes.text),
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        cursorColor: Themes.primary,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null) {
                            return "عنوان فایل را وارد کنید";
                          }
                          if (value.length >= 10) {
                            return "حداقل باید 10 کاراکتر بنویسید";
                          }
                        },
                        onSaved: ((newValue) {
                          setState(() {
                            title = newValue;
                          });
                        }),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        "توضیحات",
                        style: TextStyle(
                          fontSize: 14,
                          color: Themes.text,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "در توضیحات به جزئیات و ویژگی ها قابل توجه، دسترسی های محلی و موقعیت ملک اشاره کنید و از درج شماره تماس یا آدرس مستقیم در آن خودداری نمایید.",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontFamily: "IranSansMedium",
                          color: Themes.text,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField2(
                        decoration: InputDecoration(
                          hintText: "توضیحات را بنویسید.",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Themes.icon,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Themes.primary,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Themes.textGrey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        ),
                        style: TextStyle(fontSize: 14, color: Themes.text),
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                        cursorColor: Themes.primary,
                        maxLines: 50,
                        minLines: 6,
                        validator: (value) {
                          if (value == null) {
                            return "عنوان فایل را وارد کنید";
                          }
                          if (value.length >= 10) {
                            return "حداقل باید 10 کاراکتر بنویسید";
                          }
                        },
                        onSaved: ((newValue) {
                          setState(() {
                            description = newValue;
                          });
                        }),
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
                    height: 45,
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BuildContext? resetDialogContext;

  showResetDialog() {
    showDialog(
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

  _resetData() {
    Navigator.pop(context);
  }

  _openHelp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => UploadMediaGuide()));
  }

  next() {}
}
