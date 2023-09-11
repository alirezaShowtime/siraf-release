import 'package:flutter/material.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/main.dart';

class ViolationDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViolationDialog();

  TextEditingController? titleController;
  TextEditingController? descriptionController;
  void Function(String title, String description)? onApply;

  ViolationDialog({
    this.onApply,
    this.titleController,
    this.descriptionController,
  });
}

class _ViolationDialog extends State<ViolationDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    titleController = widget.titleController ?? TextEditingController();
    descriptionController = widget.descriptionController ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField2(
                    maxLines: 1,
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: (App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey).withOpacity(0.5), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: (App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey).withOpacity(0.5), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: App.theme.primaryColor, width: 1),
                      ),
                      hintText: "عنوان",
                      hintStyle: TextStyle(
                        color: App.theme.tooltipTheme.textStyle?.color,
                        fontSize: 13,
                        fontFamily: "IranSans",
                      ),
                    ),
                    style: TextStyle(
                      color: App.theme.textTheme.bodyLarge?.color,
                      fontSize: 13,
                      fontFamily: "IranSansMedium",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField2(
                    minLines: 6,
                    maxLines: 10,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: (App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey).withOpacity(0.5), width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: (App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey).withOpacity(0.5), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: App.theme.primaryColor, width: 1),
                      ),
                      hintText: "توضیحات",
                      hintStyle: TextStyle(
                        color: App.theme.tooltipTheme.textStyle?.color,
                        fontSize: 13,
                        fontFamily: "IranSans",
                      ),
                    ),
                    style: TextStyle(
                      color: App.theme.textTheme.bodyLarge?.color,
                      fontSize: 13,
                      fontFamily: "IranSansMedium",
                    ),
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: () async {
                            if (!titleController.text.isFill()) {
                              return notify("لطفا عنوان را وارد کنید");
                            }
                            if (!descriptionController.text.isFill()) {
                              return notify("لطفا توضیحات را وارد کنید");
                            }
                            if (titleController.text.trim().length < 2) {
                              return notify("عنوان حداقل باید شامل 2 کاراکتر باشد.");
                            }

                            if (descriptionController.text.trim().length < 10) {
                              return notify("توضیحات حداقل باید شامل 10 کاراکتر باشد.");
                            }

                            widget.onApply?.call(titleController.value.text, descriptionController.value.text);
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
  }
}
