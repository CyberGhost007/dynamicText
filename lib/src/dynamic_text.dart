// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

import 'dynamic_link_text.dart';

class DynamicText extends StatelessWidget {
  const DynamicText({
    Key? key,
    required this.text,
    this.fontSize,
    this.overflow = TextOverflow.ellipsis,
    this.fontWeight,
    this.color,
    this.maxlines,
    this.wrapWords = true,
    this.softwrap = false,
    this.textAlign = TextAlign.start,
    this.padding,
    this.textTheme,
    this.height,
    this.onTap,
    this.closeText = false,
    this.italic = false,
  }) : super(key: key);
  final String text;
  final double? fontSize;
  final double? height;
  final bool wrapWords;
  final Color? color;
  final bool softwrap;
  final int? maxlines;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final TextStyle? textTheme;
  final bool closeText;
  final bool italic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: Text(
          text,
          style: textTheme ??
              GoogleFonts.nunito(
                fontSize: fontSize,
                color: color,
                fontWeight: fontWeight ?? FontWeight.normal,
                height: height,
                fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                decoration: closeText
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
          overflow: overflow,
          softWrap: softwrap,
          textAlign: textAlign,
          maxLines: maxlines,
        ),
      ),
    );
  }
}

class DynamicTextLink extends StatelessWidget {
  const DynamicTextLink({
    Key? key,
    required this.text,
    this.fontSize,
    this.overflow,
    this.fontWeight,
    this.color,
    this.maxlines,
    this.wrapWords = true,
    this.softwrap = false,
    this.textAlign = TextAlign.start,
    this.padding,
    this.textTheme,
    this.height,
    this.closeText = false,
    this.italic = false,
    this.onTap,
  }) : super(key: key);
  final String? text;
  final double? fontSize;
  final TextStyle? textTheme;
  final bool closeText;
  final bool italic;
  final bool wrapWords;
  final Color? color;
  final bool softwrap;
  final int? maxlines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final double? height;
  final Function(dynamic url)? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: DynamicLinkText(
        text: text ?? '',
        onOpen: (url) => onTap,
        style: textTheme ??
            GoogleFonts.nunito(
              fontSize: fontSize,
              color: color,
              fontWeight: fontWeight ?? FontWeight.normal,
              height: height,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              decoration:
                  closeText ? TextDecoration.lineThrough : TextDecoration.none,
            ),
      ),
    );
  }
}
