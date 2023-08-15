import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/bloc/compressor_bloc.dart';
import 'package:siraf3/bloc/create_file_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/create_file_form_data.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/screens/create/estate_guide.dart';
import 'package:siraf3/screens/create/estate_screen.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/screens/my_files_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/text_form_field_2.dart';

class CreateFileFinal extends StatefulWidget {
  CreateFileFormData formData;

  CreateFileFinal({required this.formData, super.key});

  @override
  State<CreateFileFinal> createState() => _CreateFileFinalState();
}

class _CreateFileFinalState extends State<CreateFileFinal> {
  List<Estate> selectedEstates = [];
  CompressorBloc compressorBloc = CompressorBloc();
  CreateFileBloc bloc = CreateFileBloc();

  @override
  void dispose() {
    super.dispose();

    bloc.close();
    compressorBloc.close();
  }

  @override
  void initState() {
    super.initState();

    resetCreateFileForm = false;

    bloc.stream.listen(_listenBloc);

    compressorBloc.stream.listen(_listenCompressor);

    if (widget.formData.estates.isNotEmpty) {
      setState(() {
        selectedEstates = widget.formData.estates;
      });
    }
  }

  String? securityDescription;
  TextEditingController _securitySescriptionController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();
  String? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.7,
          title: Text(
            "ثبت نهایی",
            style: TextStyle(
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    color: Themes.textGrey.withOpacity(0.5),
                    height: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: _selectEstate,
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "دفتر / دفاتر املاک (اختیاری)",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "IranSansMedium",
                            ),
                          ),
                          Text(
                            selectedEstates.isNotEmpty ? "${selectedEstates.length} مورد" : "انتخاب",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "IranSansMedium",
                            ),
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
                  SizedBox(height: 14),
                  Text(
                    "توضیحات",
                    style: TextStyle(
                      fontSize: 14,
                      color: Themes.primary,
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
                      hintStyle: TextStyle(fontSize: 14, color: Themes.textGrey),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: App.theme.textTheme.bodyLarge?.color,
                    ),
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
                  ),
                  SizedBox(height: 14),
                  Text(
                    "توضیحات محرمانه (اختیاری)",
                    style: TextStyle(
                      fontSize: 14,
                      color: Themes.primary,
                      fontFamily: "IranSansBold",
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "در صورت نیاز توضیحاتی که فقط مشاور باید آن را ببیند بنویسید",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontFamily: "IranSansMedium",
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "توضیحات محرمانه را بنویسید.",
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
                      hintStyle: TextStyle(fontSize: 14, color: Themes.textGrey),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: App.theme.textTheme.bodyLarge?.color,
                    ),
                    onChanged: (value) {
                      setState(() {
                        securityDescription = value;
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
                        securityDescription = newValue;
                      });
                    }),
                    controller: _securitySescriptionController,
                    onTap: () {
                      var txtSelection = TextSelection.fromPosition(TextPosition(offset: _securitySescriptionController.text.length - 1));

                      if (_securitySescriptionController.selection == txtSelection) {
                        _securitySescriptionController.selection = TextSelection.fromPosition(TextPosition(offset: _securitySescriptionController.text.length));
                      }
                    },
                  ),
                ]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: MaterialButton(
                    onPressed: _finalize,
                    color: Themes.primary,
                    child: Text(
                      "ثبت نهایی",
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
            SizedBox(
              height: 10,
            ),
          ]),
        ));
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => EstateGuide()));
  }

  _selectEstate() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EstateScreen(
          estates: selectedEstates,
          city: widget.formData.city,
        ),
      ),
    );
    if (result is List<Estate>) {
      setState(() {
        selectedEstates = result;
      });
    }
  }

  _finalize() {
    if (!description.isFill()) {
      notify("لطفا توضیحات فایل را وارد کنید");
      return;
    }
    if (description!.length < 40) {
      notify("توضیحات حداقل باید 40 کاراکتر باشد");
      return;
    }
    widget.formData.estates = selectedEstates;
    widget.formData.secDescription = securityDescription;
    widget.formData.description = description!;
    var imagesFile = widget.formData.files.where((element) => checkImageExtension((element['file'] as File).path));
    var images = imagesFile.map<File>((e) => (e['file'] as File)).toList();
    var videosFile = widget.formData.files.where((element) => checkVideoExtension((element['file'] as File).path));
    var videos = videosFile.map<File>((e) => (e['file'] as File)).toList();
    compressorBloc.add(CompressorEvent(images: images, videos: videos));
  }

  _listenBloc(CreateFileState event) {
    if (event is CreateFileLoadingState) {
      showLoadingDialog();
    } else if (event is CreateFileErrorState) {
      String message = "";

      dissmisLoadingDialog();
      if (event.response?.data != null) {
        try {
          message = event.response!.data!['message'];
        } on Exception catch (e) {
          message = "خطایی در ایجاد فایل پیش آمد لطفا بعدا مجدد تلاش کنید";
        }
      } else {
        message = "خطایی در ایجاد فایل پیش آمد لطفا بعدا مجدد تلاش کنید";
      }

      showErrorDialog(message);
    } else if (event is CreateFileLoadedState) {
      dissmisLoadingDialog();
      notify("فایل با موفقیت ایجاد شد");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => HomeScreen(
                    nextScreen: MaterialPageRoute(builder: (_) => MyFilesScreen()),
                  )),
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  showLoadingDialog({String? message}) {
    showDialog2(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        loadingDContext = _;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(
            decoration: BoxDecoration(
              color: App.theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    message ?? 'در حال ایجاد فایل لطفا شکیبا باشید',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "IranSansMedium",
                      color: App.theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Loading(),
              ],
            ),
          ),
        );
      },
    );
  }

  dissmisLoadingDialog() {
    if (loadingDContext != null) {
      Navigator.pop(loadingDContext!);
    }
  }

  BuildContext? loadingDContext;

  showErrorDialog(String s) {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(
            decoration: BoxDecoration(
              color: App.theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'خطا',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontFamily: "IranSansBold",
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    s,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: App.theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _listenCompressor(CompressorState event) {
    if (event is CompressorLoadingState) {
      showLoadingDialog(message: "در حال بهینه سازی رسانه ها");
    } else if (event is CompressorFailState) {
      dissmisLoadingDialog();
      notify("خطا در بهینه سازی عکس ها و ویدیو ها رخ داد");
      bloc.add(CreateFileEvent(data: widget.formData));
    } else if (event is CompressorSuccessState) {
      dissmisLoadingDialog();
      if (event.images.isFill() || event.videos.isFill()) {
        setState(() {
          widget.formData.files = widget.formData.files.map<Map<String, dynamic>>((e) {
            if (checkImageExtension((e['file'] as File).path)) {
              e['file'] = event.images.elementAt(widget.formData.files.indexOf(e));
            }

            if (checkVideoExtension((e['file'] as File).path)) {
              e['file'] = event.videos.elementAt(widget.formData.files.indexOf(e));
            }

            return e;
          }).toList();
        });
        notify("بهینه سازی رسانه ها با موفقیت انجام شد");
      }
      bloc.add(CreateFileEvent(data: widget.formData));
    }
  }
}
