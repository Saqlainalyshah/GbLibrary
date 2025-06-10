import 'package:booksexchange/controller/authentication/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_status.dart';


class LoginController extends StateNotifier<LoginState>{
  LoginController(this.ref):super(const LoginStateLoading());
  final Ref ref;
  

  Future<bool> continueWithGoogle() async {
    state = const LoginStateLoading();
    try {
      final userCredential = await ref.read(authRepositoryProvider).signInWithGoogle();
      if (userCredential != null) {
        state = const LoginStateSuccess();
        return true;
      } else {
        state = const LoginStateError("Google sign-in failed.");
        return false;
      }
    } catch (e) {
      state = LoginStateError(e.toString());
      return false;
    }
  }

  ///Logout function
  logOut() async{
    state=const LoginStateSuccess();

    try{
      await ref.watch(authRepositoryProvider).signOut();
      state=const LoginStateLoading();
    }catch(e){
      state=LoginStateError(e.toString());
    }
  }

/*
   void continueWithFacebook()async{
     state=const LoginStateLoading();
     try{
      ref.read(authRepositoryProvider).signInWithFacebook();
      state=const LoginStateSuccess();
     }catch (e){
      state=LoginStateError(e.toString());
    }

   }
  void continueWithTwitter()async{
    state=const LoginStateLoading();
    try {
      ref.read(authRepositoryProvider).signInWithTwitter();
      state=const LoginStateSuccess();
    }catch (e){
      state=LoginStateError(e.toString());
    }
  }
  void continueWithApple()async{
    state=const LoginStateLoading();
    try {
      ref.read(authRepositoryProvider).signInWithApple();
      state=const LoginStateSuccess();
    }catch (e){
      state=LoginStateError(e.toString());
    }
  }
*/

  verifyPhoneNumber(BuildContext context, String phoneNumber) async{
    try{
      await ref.watch(authRepositoryProvider).sendOtpOnNumber(context, phoneNumber);
    } catch (e){
      state=LoginStateError(e.toString());
    }
  }
}

