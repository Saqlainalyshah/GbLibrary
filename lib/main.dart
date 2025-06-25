import 'package:booksexchange/components/text_widget.dart';
import 'package:booksexchange/screens/login_signup/login.dart';
import 'package:booksexchange/utils/fontsize/app_theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/button.dart';
import 'components/textfield.dart';
import 'controller/authentication/auth_checker.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      ProviderScope(
    child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home:  Login(),
      home: AuthChecker(),
    );
  }
}


