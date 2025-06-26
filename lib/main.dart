
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller/authentication/auth_checker.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthChecker(),
    )
  ));
}



