
import 'package:booksexchange/controller/authentication/providers.dart';
import 'package:booksexchange/screens/login_signup/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';


class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userProvider);
    return authState.when(
      data: (user) {
        if(user!=null){
          return MainScreen();
        }else{
            return Login();
        }
      },
      loading: () => Login(),
      error: (e, error) => Login(),
    );
  }
}
