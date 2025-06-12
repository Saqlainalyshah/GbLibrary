import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/login_signup/login.dart';
import '../../screens/main_screen/main_screen.dart';
import '../../utils/fontsize/app_theme/theme.dart';
import 'auth_providers.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(currentUserProvider);

    return authState.when(
      data: (user) {
        print("auth ${DateTime.now()}");
        if (user != null) {
          return Consumer(
            builder: (context, ref, child) {
              final userProfile = ref.watch(userProfileProvider(user.uid));
              return userProfile.when(
                data: (profile) {
                  print("user ${DateTime.now()}");
                  return profile != null ? MainScreen(userProfile: profile) : Login();
                },
                loading: () => Scaffold(
                  body: Center(child: CircularProgressIndicator(color: AppThemeClass.primary)),
                ),
                error: (e, error) => Login(),
              );
            },
          );
        } else {
          return Login();
        }
      },
      loading: () => Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppThemeClass.primary)),
      ),
      error: (e, error) => Login(),
    );
  }
}