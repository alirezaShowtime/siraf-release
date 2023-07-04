import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/bloc/edit_file_bloc.dart';
import 'package:siraf3/bloc/upload_file_media_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/edit_file_form_data.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/models/my_file_detail.dart';
import 'package:siraf3/screens/create/estate_guide.dart';
import 'package:siraf3/screens/create/estate_screen.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/screens/my_files_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/widgets/text_form_field_2.dart';

class EditFileFinal extends StatefulWidget {
  EditFileFormData formData;
  MyFileDetail file;

  EditFileFinal({required this.formData, required this.file, super.key});

  @override
  State<EditFileFinal> createState() => _EditFileFinalState();
}

class _EditFileFinalState extends State<EditFileFinal> {
  List<Estate> selectedEstates = [];
  EditFileBloc editBloc = EditFileBloc();
  UFMBloc ufmBloc = UFMBloc();

  String? securityDescription;
  TextEditingController _securitySescriptionController =
      TextEditingController();

  TextEditingController _descriptionController = TextEditingController();
  String? description;

  @override
  void dispose() {
    super.dispose();

    editBloc.close();
    ufmBloc.close();
  }

  @override
  void initState() {
    super.initState();

    resetEditFileForm = false;

    setEstates();

    setState(() {
      _descriptionController.text = widget.formData.description;
      _securitySescriptionController.text = widget.formData.secDescription;
      description = widget.formData.description;
      securityDescription = widget.formData.secDescription;
    });

    editBloc.stream.listen(_listenEditBloc);
    ufmBloc.stream.listen(_listenUploadMediaBloc);
  }

  setEstates() {
    setState(() {
      selectedEstates = widget.formData.estates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Themes.appBar,
          elevation: 0.7,
          title: Text(
            "تایید نهایی",
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(children: [
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
                                  color: Themes.text,
                                ),
                              ),
                              Text(
                                selectedEstates.isNotEmpty
                                    ? "${selectedEstates.length} مورد"
                                    : "انتخاب",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "IranSansMedium",
                                  color: Themes.text,
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
                          hintStyle:
                              TextStyle(fontSize: 14, color: Themes.textGrey),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                          hintStyle:
                              TextStyle(fontSize: 14, color: Themes.textGrey),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                          var txtSelection = TextSelection.fromPosition(
                              TextPosition(
                                  offset: _securitySescriptionController
                                          .text.length -
                                      1));

                          if (_securitySescriptionController.selection ==
                              txtSelection) {
                            _securitySescriptionController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: _securitySescriptionController
                                        .text.length));
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
                      "ویرایش",
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
    resetEditFileForm = true;
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
    if (! description.isNotNullOrEmpty() || description!.length < 40) {
      return notify("توضیحات باید حداقل 40 کارکتر باشد");
    }
    widget.formData.estates = selectedEstates;
    widget.formData.description = description!;
    widget.formData.secDescription = securityDescription ?? "";

    editBloc.add(EditFileEvent(data: widget.formData));
  }

  _listenEditBloc(EditFileState event) {
    if (event is EditFileLoadingState) {
      showLoadingDialog();
    } else if (event is EditFileErrorState) {
      String message = "";

      dissmisLoadingDialog();
      if (event.response?.data != null) {
        try {
          message = event.response!.data!['message'];
        } on Exception catch (e) {
          message = "خطایی در ویرایش فایل پیش آمد لطفا بعدا مجدد تلاش کنید";
        }
      } else {
        message = "خطایی در ویرایش فایل پیش آمد لطفا بعدا مجدد تلاش کنید";
      }

      showErrorDialog(message);
    } else if (event is EditFileSuccessState) {
      dissmisLoadingDialog();
      notify("اطلاعات فایل با موفقیت ویرایش شد");
      if (!widget.formData.mediaData.isEmpty()) {
        ufmBloc.add(
            UFMEvent(id: widget.formData.id, media: widget.formData.mediaData));
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => HomeScreen(
                      nextScreen:
                          MaterialPageRoute(builder: (_) => MyFilesScreen()),
                    )),
            (Route<dynamic> route) => false);
      }
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (message != null) Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
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
              color: Colors.white,
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
                      fontWeight: FontWeight.bold,
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
                      color: Themes.text,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
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

  _listenUploadMediaBloc(UFMState event) {
    if (event is UFMLoadingState) {
      showLoadingDialog(
          message: 'در حال آپلود رسانه های تصویری فایل');
    } else if (event is UFMErrorState) {
      String message = "";

      dissmisLoadingDialog();
      if (event.response?.data != null) {
        try {
          message = event.response!.data!['message'];
        } on Exception catch (e) {
          message = "خطایی در آپلود رسانه ها پیش آمد لطفا بعدا مجدد تلاش کنید";
        }
      } else {
        message = "خطایی در آپلود رسانه ها پیش آمد لطفا بعدا مجدد تلاش کنید";
      }

      showErrorDialog(message);
    } else if (event is UFMSuccessState) {
      dissmisLoadingDialog();
      notify("رسانه های با موفقیت آپلود شد");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => HomeScreen(
                    nextScreen:
                        MaterialPageRoute(builder: (_) => MyFilesScreen()),
                  )),
          (Route<dynamic> route) => false);
    }
  }
}
