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

  const CustomText({
    super.key,
    required this.text,
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
      style: GoogleFonts.poppins(
       // fontSize: 12,
               letterSpacing: -0.2,
              color: color,
              fontSize: ResponsiveText.getSize(context, fontSize??12),
              fontWeight: isBold ? FontWeight.w500 : FontWeight.w400
        //fontStyle: FontStyle.normal

            ),
    );
  }
}
