import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/create_file_form_data.dart';
import 'package:siraf3/screens/create/create_file_final.dart';
import 'package:siraf3/screens/create/upload_media_guide.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/text_form_field_2.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreateFileSecond extends StatefulWidget {
  CreateFileFormData formData;

  CreateFileSecond({required this.formData, super.key});

  @override
  State<CreateFileSecond> createState() => _CreateFileSecondState();
}

class _CreateFileSecondState extends State<CreateFileSecond> {
  String? title;
  String? visitPhone;
  String? ownerPhone;
  String? visitName;
  String? ownerName;
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

  TextEditingController _titleController = TextEditingController();
  TextEditingController _ownerPhoneController = TextEditingController();
  TextEditingController _visitPhoneController = TextEditingController();
  TextEditingController _ownerNameController = TextEditingController();
  TextEditingController _visitNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    resetCreateFileForm = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: App.getSystemUiOverlay(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "ثبت فایل",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                showResetDialog();
              },
              icon: Icon(
                Icons.refresh,
              ),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.back,
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Stack(
              children: [
                SingleChildScrollView(
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
                                ),
                              ),
                              Icon(
                                CupertinoIcons.right_chevron,
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
                        color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey.withOpacity(0.5),
                        height: 1,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "آپلود فایل های تصویری",
                        style: TextStyle(
                          fontSize: 14,
                          color: App.theme.primaryColor,
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
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: GridView(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width < 330 ? 4 : 5,
                          ),
                          children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(3),
                                  alignment: Alignment.center,
                                  child: DottedBorder(
                                    color: Themes.iconGrey,
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(5),
                                    child: Container(
                                      color: Colors.transparent,
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onPressed: _addMedia,
                                        icon: Icon(
                                          CupertinoIcons.plus,
                                          size: 28,
                                          color: Themes.iconGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ] +
                              mediaBoxes
                                  .map<Widget>(
                                    (e) => buildClickableMediaBox(e),
                                  )
                                  .toList(),
                        ),
                      ),
                      Text(
                        "عنوان",
                        style: TextStyle(
                          fontSize: 14,
                          color: App.theme.primaryColor,
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
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField2(
                        decoration: InputDecoration(
                          hintText: hints.containsKey(widget.formData.category.id!) ? hints[widget.formData.category.id!] : "مثال : آپارتمان 120 متری، میدان ونک",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
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
                              color: App.theme.primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
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
                          hintStyle: TextStyle(fontSize: 14, color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: App.theme.textTheme.bodyLarge?.color,
                        ),
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        cursorColor: App.theme.primaryColor,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "عنوان فایل را وارد کنید";
                          }
                          if (value.length <= 10) {
                            return "حداقل باید 10 کاراکتر بنویسید";
                          }
                        },
                        onSaved: ((newValue) {
                          setState(() {
                            title = newValue;
                          });
                        }),
                        controller: _titleController,
                      ),
                      SizedBox(height: 14),
                      Text(
                        "نام و نام خانوادگی مالک",
                        style: TextStyle(
                          fontSize: 14,
                          color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField2(
                        decoration: InputDecoration(
                          hintText: "نام و نام خانوادگی صاحب ملک را بنویسید.",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
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
                              color: App.theme.primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
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
                          hintStyle: TextStyle(fontSize: 14, color: App.theme.textTheme.bodyLarge?.color),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        style: TextStyle(fontSize: 14, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text),
                        onChanged: (value) {
                          setState(() {
                            ownerName = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        cursorColor: App.theme.primaryColor,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "لطفا نام و نام خانوادگی مالک را وارد نمایید";
                          }
                        },
                        onSaved: ((newValue) {
                          setState(() {
                            ownerName = newValue;
                          });
                        }),
                        controller: _ownerNameController,
                      ),
                      SizedBox(height: 14),
                      Text(
                        "شماره تماس مالک",
                        style: TextStyle(
                          fontSize: 14,
                          color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField2(
                        decoration: InputDecoration(
                          hintText: "شماره تماس صاحب ملک را بنویسید.",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
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
                              color: App.theme.primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
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
                          hintStyle: TextStyle(fontSize: 14, color: App.theme.textTheme.bodyLarge?.color),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          helperStyle: TextStyle(fontSize: 0.01),
                        ),
                        maxLength: 11,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text),
                        onChanged: (value) {
                          setState(() {
                            ownerPhone = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        cursorColor: App.theme.primaryColor,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "شماره تماس مالک را وارد کنید";
                          }
                          if (!value.startsWith("09")) {
                            return "شماره تماس باید با 09 شروع شود";
                          }
                          if (value.length != 11) {
                            return "شماره تماس باید 11 کاراکتر باشد";
                          }
                        },
                        onSaved: ((newValue) {
                          setState(() {
                            ownerPhone = newValue;
                          });
                        }),
                        controller: _ownerPhoneController,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        "نام و نام خانوادگی جهت هماهنگی بازدید (اختیاری)",
                        style: TextStyle(
                          fontSize: 13,
                          color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField2(
                        decoration: InputDecoration(
                          hintText: "نام و نام خانوادگی جهت هماهنگی بازدید را بنویسید.",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
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
                              color: App.theme.primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
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
                          hintStyle: TextStyle(fontSize: 14, color: App.theme.textTheme.bodyLarge?.color),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        style: TextStyle(fontSize: 14, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text),
                        onChanged: (value) {
                          setState(() {
                            visitName = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        cursorColor: App.theme.primaryColor,
                        maxLines: 1,
                        onSaved: ((newValue) {
                          setState(() {
                            visitName = newValue;
                          });
                        }),
                        controller: _visitNameController,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        "شماره تماس بازدید (اختیاری)",
                        style: TextStyle(
                          fontSize: 14,
                          color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField2(
                        decoration: InputDecoration(
                          hintText: "شماره تماس جهت هماهنگی بازدید را بنویسید.",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
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
                              color: App.theme.primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
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
                          hintStyle: TextStyle(fontSize: 14, color: App.theme.textTheme.bodyLarge?.color),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          helperStyle: TextStyle(fontSize: 0.01),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text),
                        onChanged: (value) {
                          setState(() {
                            visitPhone = value;
                          });
                        },
                        maxLength: 11,
                        textInputAction: TextInputAction.next,
                        cursorColor: App.theme.primaryColor,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }
                          if (!value.startsWith("09")) {
                            return "شماره تماس باید با 09 شروع شود";
                          }
                          if (value.length != 11) {
                            return "شماره تماس باید 11 کاراکتر باشد";
                          }
                        },
                        onSaved: ((newValue) {
                          setState(() {
                            visitPhone = newValue;
                          });
                        }),
                        controller: _visitPhoneController,
                      ),
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 0,
                  child: MaterialButton(
                    onPressed: next,
                    color: App.theme.primaryColor,
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
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  BuildContext? resetDialogContext;

  showResetDialog() {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        resetDialogContext = _;
        return ConfirmDialog(
          dialogContext: context,
          content: 'آیا مایل به ثبت فایل از ابتدا هستید؟',
          applyText: "بله",
          cancelText: "خیر",
          title: "بازنشانی",
          onApply: () {
            _resetData();
            dismissResetDialog();
          },
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
    resetCreateFileForm = true;
    Navigator.pop(context);
  }

  _openHelp() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => UploadMediaGuide()));
  }

  next() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    widget.formData.files = files;
    widget.formData.title = title!;
    widget.formData.ownerPhone = ownerPhone!;
    widget.formData.visitPhone = visitPhone ?? "";
    widget.formData.ownerName = ownerName!;
    widget.formData.visitName = visitName ?? "";

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateFileFinal(formData: widget.formData),
      ),
    );

    if (resetCreateFileForm) {
      _resetData();
    }
  }

  List<Widget> mediaBoxes = [];
  List<Map<String, dynamic>> files = [];

  BuildContext? addMediaBottmSheetContext;

  void _addMedia() async {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (_) {
          addMediaBottmSheetContext = _;
          return Container(
            height: 140,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: _chooseFromGallery,
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.photo,
                          color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          size: 26,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "انتخاب از گالری",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "IranSansMedium",
                            color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: _takePhotoFromCamera,
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.photo_camera,
                          color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          size: 26,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "عکس از دوربین",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "IranSansMedium",
                            color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: _takeVideoFromCamera,
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.video_camera,
                          color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          size: 26,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "فیلمبرداری",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "IranSansMedium",
                            color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  BuildContext? optionsDialog;

  showOptionsDialog(int index) {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        optionsDialog = _;
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
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                color: App.theme.primaryColor,
                              ),
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                "تنظیمات امکانات تصویری",
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
                    ListView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: [
                        if (!checkVirtualTourExtension((files[index]["file"] as io.File).path))
                          optionItem(
                            value: files[index]["title"] != null ? files[index]["title"] + " (ویرایش)" : "عنوان را وارد کنید (اختیاری)",
                            isLast: false,
                            onTap: () => _showAddTitleDialog(index),
                          ),
                        if (checkImageExtension((files[index]["file"] as io.File).path))
                          optionItem(
                            value: "انتخاب به عنوان نمایش اول",
                            isLast: false,
                            onTap: () => _moveFirst(index),
                          ),
                        optionItem(
                          value: "ویرایش",
                          isLast: false,
                          onTap: () => _editFile(index),
                        ),
                        optionItem(
                          value: "حذف",
                          isLast: true,
                          onTap: () => _deleteMedia(index),
                        ),
                      ],
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

  dismissOptionsDialog() {
    if (optionsDialog != null) {
      Navigator.pop(optionsDialog!);
    }
  }

  Future<Widget> buildMediaBox(io.File file, FileType2 type) async {
    ImageProvider<Object> image;
    Widget? icon;

    switch (type) {
      case FileType2.image:
        image = FileImage(file);
        break;
      case FileType2.video:
        final byteData = await file.readAsBytes();
        Directory tempDir = await getTemporaryDirectory();

        File tempVideo = File("${tempDir.path}/assets/" + file.uri.pathSegments.last)
          ..createSync(recursive: true)
          ..writeAsBytesSync(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

        final fileName = await VideoThumbnail.thumbnailFile(
          video: tempVideo.path,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.PNG,
          quality: 1,
        );
        image = FileImage(io.File(fileName!));
        icon = Icon(
          Icons.play_arrow_outlined,
          color: Colors.white,
          size: 27,
        );
        break;
      case FileType2.tour:
        image = AssetImage("assets/images/blue.png");
        icon = Image(
          image: AssetImage("assets/images/virtual_tour.png"),
          color: Colors.white,
          width: 27,
          height: 27,
        );
        break;
    }

    return Container(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
            colorFilter: type != FileType2.image
                ? ColorFilter.mode(
                    Themes.iconGrey,
                    BlendMode.hardLight,
                  )
                : null,
          ),
        ),
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }

  Widget optionItem({required String value, required bool isLast, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: isLast
                ? BorderSide.none
                : BorderSide(
                    color: (App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey).withOpacity(0.5),
                    width: 0.7,
                  ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: App.theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ),
    );
  }

  _deleteMedia(int index) {
    setState(() {
      files.removeAt(index);
      mediaBoxes.removeAt(index);
    });
    if (optionsDialog != null) Navigator.pop(optionsDialog!);
  }

  _editFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      io.File file = io.File(result.files.first.path!);
      if (!checkImageExtension(file.path) && !checkVideoExtension(file.path) && !checkVirtualTourExtension(file.path)) {
        notify('فرمت فایل انتخابی باید یکی از فرمت های ' + image_extensions.join(", ") + video_extensions.join(", ") + ", zip" + " باشد", duration: Duration(seconds: 4));

        return;
      }
      FileType2 type;

      if (checkImageExtension(file.path)) {
        type = FileType2.image;
      } else if (checkVideoExtension(file.path)) {
        type = FileType2.video;
      } else {
        type = FileType2.tour;
      }

      var mediaBox = await buildMediaBox(file, type);

      setState(() {
        files[index] = {
          "file": file,
          "title": files[index]['title'],
        };
        mediaBoxes[index] = mediaBox;
      });
    }

    if (optionsDialog != null) Navigator.pop(optionsDialog!);
  }

  _moveFirst(int index) {
    var file = files[index];
    var mediaBox = mediaBoxes[index];

    setState(() {
      files.removeAt(index);
      mediaBoxes.removeAt(index);

      files = [file] + files;
      mediaBoxes = [mediaBox] + mediaBoxes;
    });

    if (optionsDialog != null) Navigator.pop(optionsDialog!);
  }

  BuildContext? mediaTitleDialogContext;

  _showAddTitleDialog(int index) {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        mediaTitleDialogContext = _;
        TextEditingController _controller = TextEditingController(text: files[index]['title']);
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: App.theme.backgroundColor,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Wrap(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: TextField2(
                        maxLines: 1,
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "عنوان را وارد کنید",
                          hintStyle: TextStyle(
                            color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                            fontSize: 13,
                            fontFamily: "IranSans",
                          ),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          fontSize: 13,
                          fontFamily: "IranSansMedium",
                        ),
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
                                setState(() {
                                  files[index] = {
                                    "file": files[index]["file"],
                                    "title": _controller.text.trim().isNotEmpty ? _controller.text.trim() : null,
                                  };
                                });

                                dismissMediaTitleDialog();
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

  dismissMediaTitleDialog() {
    if (mediaTitleDialogContext != null) Navigator.pop(mediaTitleDialogContext!);
    if (optionsDialog != null) Navigator.pop(optionsDialog!);

  }

  void _chooseFromGallery() async {
    dismissDialog(addMediaBottmSheetContext);
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, allowedExtensions: image_extensions + video_extensions + ["zip"], type: FileType.custom);

    if (result != null) {
      for (PlatformFile pFile in result.files) {
        io.File file = io.File(pFile.path!);
        if (!checkImageExtension(file.path) && !checkVideoExtension(file.path) && p.extension(file.path).replaceAll('.', '').toLowerCase() != "zip") {
          notify('فرمت فایل انتخابی باید یکی از فرمت های ' + image_extensions.join(", ") + video_extensions.join(", ") + ", zip" + " باشد", duration: Duration(seconds: 4));

          return;
        }
        FileType2 type;

        if (checkImageExtension(file.path)) {
          type = FileType2.image;
        } else if (checkVideoExtension(file.path)) {
          type = FileType2.video;
        } else {
          type = FileType2.tour;
        }

        var mediaBox = await buildMediaBox(file, type);

        setState(() {
          files.add({
            "file": file,
            "title": null,
          });
          mediaBoxes.add(mediaBox);
        });
      }
    }
  }

  void _takePhotoFromCamera() async {
    dismissDialog(addMediaBottmSheetContext);
    var photo = await ImagePicker().pickImage(source: ImageSource.camera);

    if (photo == null) return;

    var file = File(photo.path);

    var mediaBox = await buildMediaBox(file, FileType2.image);

    setState(() {
      files.add({
        "file": file,
        "title": null,
      });
      mediaBoxes.add(mediaBox);
    });
  }
  
  void _takeVideoFromCamera() async {
    dismissDialog(addMediaBottmSheetContext);
    var video = await ImagePicker().pickVideo(source: ImageSource.camera);

    if (video == null) return;

    var file = File(video.path);

    var mediaBox = await buildMediaBox(file, FileType2.video);

    setState(() {
      files.add({
        "file": file,
        "title": null,
      });
      mediaBoxes.add(mediaBox);
    });
  }

  buildClickableMediaBox(Widget e) {
    return GestureDetector(
      onTap: () {
        showOptionsDialog(mediaBoxes.indexOf(e));
      },
      child: Container(
        padding: EdgeInsets.all(3),
        child: Stack(
          children: [
            e,
            if (files[mediaBoxes.indexOf(e)].containsKey('title') && files[mediaBoxes.indexOf(e)]['title'] != null)
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: App.theme.backgroundColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    files[mediaBoxes.indexOf(e)]['title'] ?? "",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "IranSansBold",
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum FileType2 { image, video, tour }
