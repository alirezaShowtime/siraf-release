import 'package:flutter/material.dart';
import 'package:siraf3/widgets/error_dialog.dart';
import 'package:siraf3/widgets/loading_dialog.dart';
import 'package:siraf3/widgets/violation_dialog.dart';

import 'widgets/my_image.dart';

BuildContext? dialogContext;

Future<T?> showDialog2<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  final CapturedThemes themes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).context,
  );

  FocusScope.of(context).unfocus();

  return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(DialogRoute<T>(
    context: context,
    builder: builder,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    settings: routeSettings,
    themes: themes,
    anchorPoint: anchorPoint,
  ));
}

BuildContext? loadingDialogContext;

loadingDialog({required BuildContext context, String? message, bool showMessage = true, void Function()? onClickCancel}) async {
  showDialog2(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      loadingDialogContext = _;
      return LoadingDialog(
        message: message,
        showMessage: showMessage,
        onClickCancel: onClickCancel,
      );
    },
  );
}

BuildContext? errorDialogContext;

BuildContext? errorDialog({required BuildContext context, String? message}) {
  showDialog2(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      errorDialogContext = _;
      return ErrorDialog(
        message: message ?? "خطایی در هنگام انجام عملیات رخ داد",
      );
    },
  );
}

void violationDialog(BuildContext context, void Function(String title, String description) onApply) {
  showDialog2(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      TextEditingController _violationControllerTitle = TextEditingController();
      TextEditingController _violationControllerDesc = TextEditingController();
      return ViolationDialog(
        titleController: _violationControllerTitle,
        descriptionController: _violationControllerDesc,
        onApply: (title, desc) {
          onApply.call(title, desc);

          Navigator.pop(_);
        },
      );
    },
  );
}

void showImageDialog({required BuildContext context, required String image, String? label}) {
  showDialog2(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: label == null ? null : EdgeInsets.all(10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null) SizedBox(height: 7),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 400,
                  minWidth: 250,
                ),
                child: MyImage(
                  background: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                  image: NetworkImage(image),
                  width: 250,
                  errorWidget: Container(
                    width: 250,
                    height: 250,
                    alignment: Alignment.center,
                    color: Colors.grey.shade100,
                    child: Text(
                      image.isNotEmpty ? "خطا" : "فاقد عکس",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontFamily: "IranSansBold",
                        fontSize: 11,
                      ),
                    ),
                  ),
                  loadingWidget: Container(
                    width: 250,
                    height: 250,
                    alignment: Alignment.center,
                    color: Colors.grey.shade100,
                    child: Text(
                      "در حال بارگذاری",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontFamily: "IranSansBold",
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ),
              if (label != null) SizedBox(height: 10),
              if (label != null)
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: "IranSansBold",
                  ),
                ),
            ],
          ),
        );
      });
}

dismissDialog(BuildContext? dialogContext) {
  try {
    if (dialogContext != null && Navigator.canPop(dialogContext)) {
      Navigator.pop(dialogContext);
    }
  } catch (e) {}
}
