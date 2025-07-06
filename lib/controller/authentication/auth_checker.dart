import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/login_signup/login.dart';
import '../../screens/main_screen/main_screen.dart';
import '../../utils/app_theme/theme.dart';
import '../providers/global_providers.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    print(" AuthChecker run time:${DateTime.now()}");
    final authState = ref.watch(currentUserAuthStatus);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GlobalThemeData.lightThemeData,
      darkTheme: GlobalThemeData.darkThemeData,
      themeMode: themeMode,
      home: authState.when(
        data: (user) {
          if (user != null) {
            return MainScreen(id: user.uid);
          } else {
            return Login();
          }
        },
        loading: () => Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppThemeClass.primary),
          ),
        ),
        error: (e, error) => Login(),
      ),
    );
  }
}
