import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:siraf3/bloc/create_file_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/create_file_form_data.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/screens/create/estate_guide.dart';
import 'package:siraf3/screens/create/estate_screen.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/screens/my_files_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';

class CreateFileFinal extends StatefulWidget {
  CreateFileFormData formData;

  CreateFileFinal({required this.formData, super.key});

  @override
  State<CreateFileFinal> createState() => _CreateFileFinalState();
}

class _CreateFileFinalState extends State<CreateFileFinal> {
  List<Estate> selectedEstates = [];
  CreateFileBloc bloc = CreateFileBloc();

  @override
  void dispose() {
    super.dispose();

    bloc.close();
  }

  @override
  void initState() {
    super.initState();

    resetCreateFileForm = false;

    bloc.stream.listen(_listenBloc);
  }

  String? securityDescription;
  TextEditingController _securitySescriptionController = TextEditingController();

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
    widget.formData.estates = selectedEstates;
    widget.formData.secDescription = securityDescription;
    bloc.add(CreateFileEvent(data: widget.formData));
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => HomeScreen(
              nextScreen: MaterialPageRoute(builder: (_) => MyFilesScreen()),
            )),
            (Route<dynamic> route) => false,
      );
    }
  }

  showLoadingDialog() {
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
                    'در حال ایجاد فایل لطفا شکیبا باشید',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
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
}
