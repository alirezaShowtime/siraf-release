import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

import 'text_field_2.dart';
import 'package:siraf3/main.dart';

class MyTextField extends TextField2 {
  bool isOptional;

  MyTextField({
    super.key,
    super.controller,
    super.focusNode,
    super.keyboardType,
    super.textCapitalization,
    super.textInputAction,
    super.strutStyle,
    super.textDirection,
    super.textAlign,
    super.textAlignVertical,
    super.autofocus,
    super.readOnly,
    super.toolbarOptions,
    super.showCursor,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLengthEnforcement,
    super.maxLines,
    super.minLines,
    super.expands,
    super.maxLength,
    super.onChanged,
    super.onTap,
    super.onEditingComplete,
    super.inputFormatters,
    super.enabled,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorColor,
    super.keyboardAppearance,
    super.scrollPadding,
    super.enableInteractiveSelection,
    super.selectionControls,
    super.buildCounter,
    super.scrollPhysics,
    super.autofillHints,
    super.scrollController,
    super.restorationId,
    super.enableIMEPersonalizedLearning,
    super.mouseCursor,
    super.onSubmitted,
    this.isOptional = false,
    InputDecoration? decoration,
    TextStyle? style,
  }) : super(
          style: (style ?? TextStyle()).copyWith(color: App.theme.textTheme.bodyLarge?.color ?? Themes.text, fontSize: 12),
          decoration: (decoration ?? InputDecoration()).copyWith(
            border: new OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintStyle: TextStyle(color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey, fontSize: 10),
            labelStyle: TextStyle(color: App.theme.textTheme.bodyLarge?.color ?? Themes.text, fontSize: 14, fontFamily: "IranSansBold"),
            labelText: null,
            counterStyle: TextStyle(
              fontSize: 9,
              fontFamily: "IranSansBold",
            ),
            label: !isOptional
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${decoration?.labelText}  ",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "IranSansBold",
                          color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                          height: 1,
                        ),
                      ),
                      Text(
                        "(اختیاری)",
                        style: TextStyle(
                          fontSize: 9,
                          fontFamily: "IranSansBold",
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
          ),
        );
}
