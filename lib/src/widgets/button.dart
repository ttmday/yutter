import 'package:flutter/material.dart';

import 'package:yutter/src/constants/color.dart';
import 'package:yutter/src/constants/design.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    this.filled = true,
    this.style,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.disabled = false,
  });

  final void Function() onPressed;
  final String text;
  final bool filled;
  final TextStyle? style;
  final Color? textColor;
  final Color? color;

  final double? width;
  final double? height;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final maxWidth = 356.0;
    return MaterialButton(
      onPressed: disabled ? null : onPressed,
      disabledColor: AppColors.accent.withValues(alpha: .13),
      height: height ?? 45.0,
      minWidth: width != null && width! > maxWidth ? maxWidth : width,
      color: filled ? color ?? AppColors.primary : null,
      shape: RoundedRectangleBorder(
        side: !filled
            ? BorderSide(color: color ?? AppColors.primary)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(AppDesign.radius * 1.2),
      ),
      child: Text(
        text,
        style:
            style ??
            AppDesign.textTheme(context).bodyMedium!.copyWith(
              fontSize: 15.0,
              color: !filled
                  ? (color ?? AppColors.text)
                  : textColor ?? (color ?? AppColors.foreground),
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
