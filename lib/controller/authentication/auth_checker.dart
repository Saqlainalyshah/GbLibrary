import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/login_signup/login.dart';
import '../../screens/main_screen/main_screen.dart';
import '../../utils/app_theme/theme.dart';
import '../../utils/fontsize/responsive_text.dart';
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
        loading: () => Splash(),
        error: (e, error) => Login(),
      ),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            spacing: 50,
            mainAxisSize: MainAxisSize.min,
            children: [
             // SizedBox(height: 100),
              RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  text: TextSpan(
                    style: TextStyle(
                      fontSize: ResponsiveBox.getSize(context, 50)
                    ),
                      children: [
                        TextSpan(
                            text: "Gilgit",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                            )
                        ),
                        TextSpan(text: "Swap",style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.primary,
                        ),
          
                        )
                      ]
                  )),
              Center(
                child: CircularProgressIndicator(color: AppThemeClass.primary),
              ),
            ],
          ),
        )
    );
  }
}

