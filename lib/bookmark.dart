import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/main.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:dio/dio.dart' as dio;

class Bookmark {
  int id;
  bool isFavorite;
  BuildContext context;

  StreamController<bool> favoriteStream = StreamController();

  Bookmark({required this.id, required this.isFavorite, required this.context});

  addOrRemoveFavorite({bool withNote = false, int? noteId}) async {
    if (isFavorite) {
      removeFavorite(withNote: withNote, noteId: noteId);
    } else {
      showNoteDialog();
    }
  }

  BuildContext? noteDialogContext;

  showNoteDialog() async {
    TextEditingController _controller = TextEditingController();

    return showDialog2(
      context: context,
      builder: (_) {
        noteDialogContext = _;
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
                    SizedBox(
                      height: 40,
                      child: Container(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            "نشان کردن فایل",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "IranSansMedium",
                              color: App.theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 9),
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: TextField2(
                        minLines: 5,
                        maxLines: 5,
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "در صورت نیاز یادداشت بنویسید.",
                          hintStyle: TextStyle(
                            color: App.theme.tooltipTheme.textStyle?.color,
                            fontSize: 13,
                            fontFamily: "IranSans",
                          ),
                        ),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: App.theme.textTheme.bodyLarge?.color,
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
                              onPressed: () async {
                                dismissDialog(noteDialogContext);
                                addFavorite();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              color: Themes.secondary2,
                              elevation: 1,
                              height: 50,
                              child: Text(
                                "ذخیره بدون یادداشت",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: "IranSansBold",
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 9),
                            ),
                          ),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () async {
                                if (_controller.text.trim().isEmpty) {
                                  notify("لطفا یادداشت برای فایل بنویسید.");
                                  return;
                                }
                                dismissDialog(noteDialogContext);
                                addFavorite(note: _controller.text.trim());
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
                                "ذخیره با یادداشت",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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

  void addFavorite({String? note}) async {
    var result = false;

    showLoadingDialog();

    try {
      var response = await http2.getWithToken(
        getFileUrl('file/addFileFavorite/${id}'),
      );

      if (isResponseOk(response)) {
        result = true;
      } else {
        var json = jDecode(response.body);
        notify(json['message'] ?? "خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
        result = false;
      }
    } catch (_) {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    }

    if (note != null) {
      var url = getFileUrl('note/addNoteFile/');

      var response = await http2.postJsonWithToken(
        url,
        body: {'note': note, 'fileId': id},
      );

      if (!isResponseOk(response)) {
        notify("خطای غیر منتظره ای رخ داد لطفا مجدد تلاش کنید");
        result = false;
      }
    }

    Navigator.of(context, rootNavigator: true).pop();

    if (result) {
      isFavorite = !isFavorite;
    }
    favoriteStream.add(isFavorite);
  }

  void removeFavorite({bool withNote = false, int? noteId}) async {
    showLoadingDialog();

    var result = false;

    var response = await dio.Dio().delete(
      getFileUrl('file/deleteFileFavorite/?fileIds=[${id}]').toString(),
      options: dio.Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": await User.getBearerToken(),
        },
        validateStatus: (status) {
          return true;
        },
      ),
    );

    if (response.statusCode == 200) {
      result = true;
    } else {
      if (!withNote) {
        var json = response.data;

        notify(json['message'] ?? "سرور با خطا مواجه شد لطفا بعدا تلاش کنید");
      }
      result = false;
    }

    if (withNote && noteId != null) {
      response = await dio.Dio().post(
        getFileUrl('note/removeNoteFile/${noteId}/').toString(),
        options: dio.Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": await User.getBearerToken(),
          },
          validateStatus: (status) {
            return true;
          },
        ),
      );

      if (response.statusCode == 200) {
        result = true;
      } else {
        var json = response.data;

        notify(json['message'] ?? "سرور با خطا مواجه شد لطفا بعدا تلاش کنید 1");
        result = false;
      }
    }

    Navigator.of(context, rootNavigator: true).pop();

    if (result) {
      isFavorite = !isFavorite;
    }
    favoriteStream.add(isFavorite);
  }

  showLoadingDialog() {
    loadingDialog(context: context, showMessage: false);
  }

  dismissLoadingDialog() {
    dismissDialog(loadingDialogContext);
  }

  static Future<bool> removeFavoriteList({required BuildContext context, required List<int> ids}) async {
    loadingDialog(context: context, showMessage: false);

    var result = false;

    var response = await dio.Dio().delete(
      getFileUrl('file/deleteFileFavorite/?fileIds=' + jsonEncode(ids)).toString(),
      options: dio.Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": await User.getBearerToken(),
        },
        validateStatus: (status) {
          return true;
        },
      ),
    );

    if (response.statusCode == 200) {
      result = true;
    } else {
      var json = response.data;
      notify(json['message'] ?? "خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
      result = false;
    }

    Navigator.of(context, rootNavigator: true).pop();

    // dismissDialog(loadingDialogContext);

    return result;
  }
}
