import 'package:booksexchange/components/text_widget.dart';
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
                  if(profile!=null){
                    print("inside profile");
                    return MainScreen(userProfile: profile);
                  }else{
                    print("inside profile else");
                    // Trigger refresh after build
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.invalidate(userProfileProvider(user.uid));
                    });

                    return Scaffold(
                      backgroundColor: AppThemeClass.whiteText,
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(text: "Loading...",fontSize: 15,isGoogleFont: true,),
                            CircularProgressIndicator(color: AppThemeClass.primary,)
                          ],
                        ),
                      ),
                    );
                  }
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