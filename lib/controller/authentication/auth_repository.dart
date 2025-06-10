import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;
  Stream<User?> get authStateChange => _auth.authStateChanges();


  /// Send OTP to Phone Number
  Future<void> sendOtpOnNumber(BuildContext context, String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          if(context.mounted){
          //  Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (_) => HomeScreen()));
          }
        },
        verificationFailed: (FirebaseAuthException ex) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${ex.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpReceivedScreen(verificationId: verificationId, phoneNumber: phoneNumber),
            ),
          );*/
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto retrieval timeout for verification ID: $verificationId");
        },
      );
    } catch (e) {
      throw AuthException("Failed to send OTP: $e");
    }
  }

  /// ✅ Verify OTP Code
  Future<void> verifyingOtpCode(BuildContext context, String verificationId, String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      await _auth.signInWithCredential(credential);
      if(context.mounted){
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    } catch (e) {
     if(context.mounted){
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Incorrect OTP. Please try again.')),
       );
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignInScreen()));
     }
    }
  }

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw AuthException("Google sign-in was canceled.");
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw AuthException("Failed to sign in with Google: $e");
    }
  }

  /// ✅ Sign out (Firebase + Google)
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      throw AuthException("Failed to sign out: $e");
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
