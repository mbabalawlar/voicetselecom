import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';

class FFButtonOptions {
  const FFButtonOptions({
    this.textStyle,
    this.elevation,
    this.height,
    this.width,
    this.padding,
    this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    this.borderRadius,
    this.borderSide,
  });

  final TextStyle textStyle;
  final double elevation;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color disabledColor;
  final Color disabledTextColor;
  final Color splashColor;
  final double iconSize;
  final Color iconColor;
  final EdgeInsetsGeometry iconPadding;
  final double borderRadius;
  final BorderSide borderSide;
}

class FFButtonWidget extends StatelessWidget {
  const FFButtonWidget({
    @required this.text,
    @required this.onPressed,
    this.iconData,
    @required this.options,
  });

  final String text;
  final IconData iconData;
  final VoidCallback onPressed;
  final FFButtonOptions options;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: options.textStyle,
      maxLines: 1,
    );
    if (iconData != null) {
      return Container(
        height: options.height,
        width: options.width,
        child: ElevatedButton.icon(
          icon: Padding(
            padding: EdgeInsets.zero,
            child: Icon(
              iconData,
              size: options.iconSize,
              color: options.textStyle.color,
            ),
          ),
          label: textWidget,
          onPressed: onPressed,
        ),
      );
    }

    return Container(
      height: options.height,
      width: options.width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: textWidget,
      ),
    );
  }
}
