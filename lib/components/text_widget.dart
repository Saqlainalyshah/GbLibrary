import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Text Widget

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final bool isBold;
  final int? maxLines;
  final TextAlign? textAlign;
  final bool isGoogleFont;
  const CustomText({
    super.key,
    required this.text,
    this.isGoogleFont = true,
    this.textAlign = TextAlign.start,
    this.maxLines = 300,
    this.fontSize = 13,
    this.color = Colors.black,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: maxLines,
      textAlign: textAlign,
      style: isGoogleFont
          ? GoogleFonts.robotoSerif(
              color: color,
             // letterSpacing: isBold?1:0,
              fontSize: ResponsiveText.getSize(context, fontSize),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            )
          : TextStyle(
              letterSpacing: 0,
              color: color,
              fontSize: ResponsiveText.getSize(context, fontSize),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
    );
  }
}
