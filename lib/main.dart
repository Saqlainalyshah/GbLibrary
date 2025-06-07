import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/screens/login_signup/login.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/button.dart';
import 'components/textfield.dart';

void main() {
  runApp(
      ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
     // home:  Login(),
      home: Login(),
    ),
  ));
}




