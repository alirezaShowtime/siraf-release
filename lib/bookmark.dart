import 'dart:async';

import 'package:flutter/material.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/http2.dart' as http2;

class Bookmark {
  int id;
  bool isFavorite;
  BuildContext context;

  StreamController<bool> favoriteStream = StreamController();

  Bookmark({required this.id, required this.isFavorite, required this.context});

  addOrRemoveFavorite() async {
    if (isFavorite) {
      removeFavorite();
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
                        minLines: 3,
                        maxLines: 5,
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "در صورت نیاز یادداشت بنویسید.",
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
                              onPressed: () async {
                                if (_controller.text.trim().isEmpty) {
                                  dismissDialog(noteDialogContext);
                                  addFavorite();
                                  return;
                                }
                                dismissDialog(noteDialogContext);
                                addFavorite(note: _controller.text.trim());
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
                                "ثبت",
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
        notify(json['message'] ??
            "خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
        result = false;
      }
    } catch (_) {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    }

    if (note != null) {
      var url = getFileUrl('note/addNoteFile/${id}/');

      var response = await http2.postJsonWithToken(
        url,
        body: {'note': note},
      );

      if (!isResponseOk(response)) {
        notify("خطای غیر منتظره ای رخ داد لطفا مجدد تلاش کنید");
        result = false;
      }
    }

    dismissLoadingDialog();

    if (result) {
      isFavorite = !isFavorite;
    }
    favoriteStream.add(isFavorite);
  }

  void removeFavorite() async {
    showLoadingDialog();

    var result = false;

    try {
      var response = await http2.getWithToken(
        getFileUrl('file/deleteFileFavorite/${id}/'),
      );

      if (isResponseOk(response)) {
        result = true;
      } else {
        var json = jDecode(response.body);
        notify(json['message'] ??
            "خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
        result = false;
      }
    } catch (_) {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    }

    dismissLoadingDialog();

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
}
