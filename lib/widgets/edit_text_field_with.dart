import 'package:disciple/app/common/app_colors.dart';
import 'package:disciple/app/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditTextFieldWidget extends ConsumerWidget {
  const EditTextFieldWidget({
    super.key,
    this.label = '',
    this.title,
    this.controller,
    this.focusNode,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.obscureText = false,
    this.autocorrect = false,
    this.onTap,
    this.onFieldSubmitted,
    this.onChanged,
    this.obscuringCharacter = '*',
    this.textInputAction = TextInputAction.next,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.suffixIcon,
    this.prefix,
    this.titleStyle,
    this.inputFormatters,
    this.contentPadding,
    this.maxLines = 1,
    this.hintMaxLines = 1,
    this.alignLabelWithHint,
    this.titleWidget,
    this.style,
    this.labelStyle,
    this.suffixText,
    this.suffixStyle,
    this.hintStyle,
    this.focusedBorder,
    this.fillColor,
  });

  final String? title;
  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final bool obscureText;
  final String obscuringCharacter;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final bool autocorrect;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final int? hintMaxLines;
  final bool? alignLabelWithHint;

  final Widget? titleWidget;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final Color? fillColor;
  final String? suffixText;
  final TextStyle? suffixStyle;
  final TextStyle? hintStyle;
  final InputBorder? focusedBorder;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      titleWidget ??
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? '',
                style:
                    titleStyle ??
                    context.headlineLarge?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: validator,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        readOnly: readOnly,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        onTap: onTap,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        textInputAction: textInputAction,
        autovalidateMode: autovalidateMode,
        autocorrect: autocorrect,
        style:
            style ??
            context.headlineLarge?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
        decoration: InputDecoration(
          label: Text(label),
          labelStyle: labelStyle,
          fillColor: fillColor,
          hintText: label,
          focusedBorder: focusedBorder,
          suffixIcon: suffixIcon,
          hintMaxLines: hintMaxLines,
          suffixText: suffixText,
          hintStyle: hintStyle,
          suffixStyle: suffixStyle,
          prefixIcon: prefix,
          contentPadding: contentPadding,
          alignLabelWithHint: alignLabelWithHint,
        ),
        inputFormatters: inputFormatters,
        maxLines: maxLines,
      ),
    ],
  );
}

class EditTextFieldWidget2 extends ConsumerWidget {
  const EditTextFieldWidget2({
    super.key,
    this.label = '',
    this.title,
    this.controller,
    this.focusNode,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.obscureText = false,
    this.autocorrect = false,
    this.onTap,
    this.onFieldSubmitted,
    this.onChanged,
    this.obscuringCharacter = '*',
    this.textInputAction = TextInputAction.next,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.suffixIcon,
    this.prefix,
    this.titleStyle,
    this.inputFormatters,
    this.contentPadding,
    this.maxLines = 1,
    this.alignLabelWithHint,
    this.titleWidget,
    this.style,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor = AppColors.grey300,
  });

  final String? title;
  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final bool obscureText;
  final String obscuringCharacter;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final bool autocorrect;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final bool? alignLabelWithHint;
  final Widget? titleWidget;
  final TextStyle? style;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (titleWidget != null || title != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child:
              titleWidget ??
              Text(
                title ?? '',
                style:
                    titleStyle ??
                    TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
        ),
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: .79.w),
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          readOnly: readOnly,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          onTap: onTap,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          textInputAction: textInputAction,
          autovalidateMode: autovalidateMode,
          autocorrect: autocorrect,
          style: style ?? context.headlineMedium,
          decoration: InputDecoration(
            labelText: label,
            fillColor: fillColor,
            filled: fillColor != null,

            suffixIcon: suffixIcon,
            prefixIcon: prefix,
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            alignLabelWithHint: alignLabelWithHint,
          ),
          inputFormatters: inputFormatters,
          maxLines: maxLines,
        ),
      ),
    ],
  );
}

class CupertinoEditTextFieldWidget extends ConsumerWidget {
  const CupertinoEditTextFieldWidget({
    super.key,
    this.label = '',
    this.title,
    this.controller,
    this.focusNode,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.obscureText = false,
    this.autocorrect = false,
    this.onTap,
    this.onFieldSubmitted,
    this.onChanged,
    this.obscuringCharacter = '*',
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.prefix,
    this.titleStyle,
    this.contentPadding,
    this.maxLines = 1,
    this.alignLabelWithHint,
    this.titleWidget,
    this.style,
    this.fillColor,
    this.suffix,
    this.radius = 10,
    this.errorMessage,
    this.error = false,
  });

  final String? title;
  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool readOnly;
  final bool obscureText;
  final String obscuringCharacter;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final bool autocorrect;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final bool? alignLabelWithHint;

  final Widget? titleWidget;
  final TextStyle? style;
  final Color? fillColor;
  final Widget? suffix;
  final double radius;
  final String? errorMessage;
  final bool error;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      titleWidget ??
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? '',
                style: titleStyle ?? TextStyle(fontSize: 12.sp),
              ),
              const SizedBox(height: 8),
            ],
          ),
      CupertinoTextField(
        controller: controller,
        focusNode: focusNode,
        placeholder: label,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        readOnly: readOnly,
        obscureText: obscureText,
        onTap: onTap,
        onSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        padding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        style: style,
        decoration: BoxDecoration(
          color: fillColor ?? Colors.transparent,
          border: Border.all(color: CupertinoColors.systemGrey, width: 0.5),
          borderRadius: BorderRadius.circular(radius.r),
        ),
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        suffix: suffix,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          errorMessage ?? '',
          style: TextStyle(
            color: error ? Colors.red : AppColors.grey500,
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ],
  );
}
