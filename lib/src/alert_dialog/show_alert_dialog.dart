import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Show alert dialog, whose appearance is adaptive according to platform
///
/// [useActionSheetForCupertino] (default: false) only works for
/// cupertino style. If it is set to true, [showModalActionSheet] is called
/// instead.
Future<T> showAlertDialog<T>({
  @required BuildContext context,
  String title,
  String message,
  List<AlertDialogAction<T>> actions = const [],
  bool barrierDismissible = true,
  AdaptiveStyle style = AdaptiveStyle.adaptive,
  bool useActionSheetForCupertino = false,
  bool useRootNavigator = true,
}) {
  void pop(T key) => Navigator.of(
        context,
        rootNavigator: useRootNavigator,
      ).pop(key);
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final isCupertinoStyle = style.isCupertinoStyle(theme);
  if (isCupertinoStyle && useActionSheetForCupertino) {
    return showModalActionSheet(
      context: context,
      title: title,
      message: message,
      cancelLabel: actions.findCancelLabel(),
      actions: actions.convertToSheetActions(),
      style: style,
      useRootNavigator: useRootNavigator,
    );
  }
  final titleText = title == null ? null : Text(title);
  final messageText = message == null ? null : Text(message);
  return style.isCupertinoStyle(theme)
      ? showCupertinoDialog(
          context: context,
          useRootNavigator: useRootNavigator,
          builder: (context) => CupertinoAlertDialog(
            title: titleText,
            content: messageText,
            actions: actions.convertToCupertinoDialogActions(
              onPressed: pop,
            ),
          ),
        )
      : showDialog2020(
          context: context,
          useRootNavigator: useRootNavigator,
          barrierDismissible: barrierDismissible,
          builder: (context) => AlertDialog(
            title: titleText,
            content: messageText,
            actions: actions.convertToMaterialDialogActions(
              onPressed: pop,
              destructiveColor: colorScheme.error,
            ),
          ),
        );
}

// Used to specify [showOkCancelAlertDialog]'s [defaultType]
enum OkCancelAlertDefaultType {
  ok,
  cancel,
}