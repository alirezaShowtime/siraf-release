import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/bloc/edit_file_bloc.dart';
import 'package:siraf3/bloc/upload_file_media_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/edit_file_form_data.dart';
import 'package:siraf3/models/estate.dart';
import 'package:siraf3/models/my_file_detail.dart';
import 'package:siraf3/screens/create/estate_guide.dart';
import 'package:siraf3/screens/create/estate_screen.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/screens/my_files_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/dialog.dart';

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

  @override
  void initState() {
    super.initState();

    setEstates();

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
    Navigator.pop(context, "reset");
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
    editBloc.add(EditFileEvent(data: widget.formData));
  }

  _listenEditBloc(EditFileState event) {
    if (event is EditFileLoadingState) {
      showLoadingDialog(message: 'در حال ویرایش فایل لطفا شکیبا باشید');
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    message ?? 'در حال انجام عملیات هستیم لطفا شکیبا باشید.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
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
          message: 'در حال آپلود رسانه های تصویری هستیم کمی صبر کنید');
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
