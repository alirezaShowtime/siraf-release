import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/create_file_form_data.dart';
import 'package:siraf3/screens/create/create_file_final.dart';
import 'package:siraf3/screens/create/upload_media_guide.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

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

  TextEditingController _titleController = TextEditingController();
  TextEditingController _ownerPhoneController = TextEditingController();
  TextEditingController _visitPhoneController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

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
                        height: 5,
                      ),
                      Container(
                        child: GridView(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width < 330 ? 4 : 5,
                          ),
                          children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5),
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
                                    (e) => GestureDetector(
                                      onTap: () {
                                        showOptionsDialog(
                                            mediaBoxes.indexOf(e));
                                      },
                                      child: e,
                                    ),
                                  )
                                  .toList(),
                        ),
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
                      TextFormField(
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
                        textInputAction: TextInputAction.next,
                        cursorColor: Themes.primary,
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
                        onTap: () {
                          var txtSelection = TextSelection.fromPosition(
                              TextPosition(
                                  offset: _titleController.text.length - 1));

                          if (_titleController.selection == txtSelection) {
                            _titleController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: _titleController.text.length));
                          }
                        },
                      ),
                      SizedBox(height: 14),
                      Text(
                        "شماره تماس مالک",
                        style: TextStyle(
                          fontSize: 14,
                          color: Themes.text,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "شماره تماس صاحب ملک را بنویسید.",
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
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14, color: Themes.text),
                        onChanged: (value) {
                          setState(() {
                            ownerPhone = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        cursorColor: Themes.primary,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "شماره تماس مالک را وارد کنید";
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
                        onTap: () {
                          var txtSelection = TextSelection.fromPosition(
                              TextPosition(
                                  offset:
                                      _ownerPhoneController.text.length - 1));

                          if (_ownerPhoneController.selection == txtSelection) {
                            _ownerPhoneController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: _ownerPhoneController.text.length));
                          }
                        },
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        "شماره تماس بازدید",
                        style: TextStyle(
                          fontSize: 14,
                          color: Themes.text,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "شماره تماس جهت هماهنگی بازدید را بنویسید.",
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
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 14, color: Themes.text),
                        onChanged: (value) {
                          setState(() {
                            visitPhone = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        cursorColor: Themes.primary,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "شماره تماس بازدید را وارد کنید";
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
                        onTap: () {
                          var txtSelection = TextSelection.fromPosition(
                              TextPosition(
                                  offset:
                                      _visitPhoneController.text.length - 1));

                          if (_visitPhoneController.selection == txtSelection) {
                            _visitPhoneController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: _visitPhoneController.text.length));
                          }
                        },
                      ),
                      SizedBox(height: 14),
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
                      TextFormField(
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
                          if (value == null || value.isEmpty) {
                            return "توضیحات فایل را وارد کنید";
                          }
                          if (value.length <= 40) {
                            return "حداقل باید 40 کاراکتر بنویسید";
                          }
                        },
                        onSaved: ((newValue) {
                          setState(() {
                            description = newValue;
                          });
                        }),
                        controller: _descriptionController,
                        onTap: () {
                          var txtSelection = TextSelection.fromPosition(
                              TextPosition(
                                  offset:
                                      _descriptionController.text.length - 1));

                          if (_descriptionController.selection ==
                              txtSelection) {
                            _descriptionController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset:
                                        _descriptionController.text.length));
                          }
                        },
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

  _resetData() {
    Navigator.pop(context, {"result"});
  }

  _openHelp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => UploadMediaGuide()));
  }

  next() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    widget.formData.files = files;
    widget.formData.title = title!;
    widget.formData.ownerPhone = ownerPhone!;
    widget.formData.visitPhone = visitPhone!;
    widget.formData.description = description!;

    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateFileFinal(formData: widget.formData),
      ),
    );

    if (result == "reset") {
      print("reset");
    }
  }

  List<Widget> mediaBoxes = [];
  List<Map<String, dynamic>> files = [];

  void _addMedia() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      for (PlatformFile pFile in result.files) {
        io.File file = io.File(pFile.path!);
        if (!checkImageExtension(file.path) &&
            !checkVideoExtension(file.path) &&
            p.extension(file.path).replaceAll('.', '').toLowerCase() != "zip") {
          notify(
              'فرمت فایل انتخابی باید یکی از فرمت های ' +
                  image_extensions.join(", ") +
                  video_extensions.join(", ") +
                  ", zip" +
                  " باشد",
              duration: Duration(seconds: 4));

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

  BuildContext? optionsDialog;

  showOptionsDialog(int index) {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        optionsDialog = _;
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
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                color: Themes.primary,
                              ),
                              height: 40,
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
                        if (!checkVirtualTourExtension(
                            (files[index]["file"] as io.File).path))
                          optionItem(
                            value: "عنوان را وارد کنید (اختیاری)",
                            isLast: false,
                            onTap: () => _showAddTitleDialog(index),
                          ),
                        if (checkImageExtension(
                            (files[index]["file"] as io.File).path))
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

        File tempVideo =
            File("${tempDir.path}/assets/" + file.uri.pathSegments.last)
              ..createSync(recursive: true)
              ..writeAsBytesSync(byteData.buffer
                  .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

        final fileName = await VideoThumbnail.thumbnailFile(
          video: tempVideo.path,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.PNG,
          quality: 100,
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
      padding: EdgeInsets.all(5),
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

  Widget optionItem(
      {required String value, required bool isLast, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
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
            value,
            style: TextStyle(
              fontSize: 13,
              color: Themes.text,
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
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      io.File file = io.File(result.files.first.path!);
      if (!checkImageExtension(file.path) &&
          !checkVideoExtension(file.path) &&
          !checkVirtualTourExtension(file.path)) {
        notify(
            'فرمت فایل انتخابی باید یکی از فرمت های ' +
                image_extensions.join(", ") +
                video_extensions.join(", ") +
                ", zip" +
                " باشد",
            duration: Duration(seconds: 4));

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
        TextEditingController _controller =
            TextEditingController(text: files[index]['title']);
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
                        maxLines: 1,
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "عنوان را وارد کنید",
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
                                setState(() {
                                  files[index] = {
                                    "file": files[index]["file"],
                                    "title": _controller.text.trim().isNotEmpty
                                        ? _controller.text.trim()
                                        : null,
                                  };
                                });

                                dismissMediaTitleDialog();
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

  dismissMediaTitleDialog() {
    if (mediaTitleDialogContext != null)
      Navigator.pop(mediaTitleDialogContext!);
    if (optionsDialog != null) Navigator.pop(optionsDialog!);

    print(files);
  }
}

enum FileType2 { image, video, tour }
