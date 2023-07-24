import 'package:flutter/material.dart';
import 'package:siraf3/widgets/error_dialog.dart';
import 'package:siraf3/widgets/loading_dialog.dart';

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

dismissDialog(BuildContext? dialogContext) {
  try {
    if (dialogContext != null && Navigator.canPop(dialogContext)) {
      Navigator.pop(dialogContext);
    }
  } catch (e) {}
}
