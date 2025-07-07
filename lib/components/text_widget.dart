import 'package:booksexchange/utils/fontsize/responsive_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///Text Widget

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final bool isBold;
  final int? maxLines;
  final TextAlign? textAlign;
  final bool isGoogleFont;
  const CustomText({
    super.key,
    required this.text,
    this.isGoogleFont = false,
    this.textAlign = TextAlign.start,
    this.maxLines = 300,
    this.fontSize,
    this.color,
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
          ?GoogleFonts.robotoSerif(
              color:color,
             letterSpacing: -0.4,
              fontSize: fontSize!=null? ResponsiveText.getSize(context, fontSize??12):null,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w300,
            )
          : TextStyle(

       // fontSize: 12,
               letterSpacing: -0.4,
              color: color,
              fontSize:fontSize!=null? ResponsiveText.getSize(context, fontSize??12):null,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
    );
  }
}
