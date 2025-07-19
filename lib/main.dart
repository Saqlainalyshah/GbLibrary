
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller/authentication/auth_checker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  runApp(
      ProviderScope(
    child: AuthChecker(),
  ));
}

