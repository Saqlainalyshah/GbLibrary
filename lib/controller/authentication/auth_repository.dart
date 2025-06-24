import 'package:booksexchange/controller/firebase_crud_operations/firestore_crud_operations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../model/user_profile.dart';


class AuthRepository {

  final FirebaseAuth auth=FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Stream<User?> get authStateChange => auth.authStateChanges();

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      final google= GoogleSignIn();
     // google.forceCodeForRefreshToken;
      //await google.disconnect();
      final GoogleSignInAccount? googleUser = await google.signIn();
      if (googleUser == null) return false; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final doc = await _fireStore.collection('users').doc(user.uid).get();
        final exists=doc.exists;
        if (!exists) {
          final userdata = UserProfile(
            createdAt:DateTime.now(),
            uid: user.uid,
            profilePicUrl: user.photoURL ?? '',
            name: user.displayName ?? '',
            email: user.email ?? '',
            gender: '',
            address: '',
            number: user.phoneNumber ?? '',
          );

          await _fireStore.collection('users').doc(user.uid).set(userdata.toJson());
        }
        return true; // Sign-in succeeded
      }
      return false; // Something went wrong, user is null
    } catch (e) {
      print("Google Sign-In error: $e");
      return false; // Sign-in failed
    }
  }

  /// ✅ Sign out (Firebase + Google)
  Future<void> signOut() async {
    try {
      await auth.signOut();

      final googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect(); // Fully disconnects and clears session
      await googleSignIn.signOut();    // Optional, but good practice
    } catch (e) {
      throw AuthException("Failed to sign out: $e");
    }
  }
  Future<bool> deleteAccount() async {
    final user = auth.currentUser;
    if (user == null) return false;

    try {
      // Delete Firestore user profile
      await _fireStore.collection('users').doc(user.uid).delete();
      // Delete Firebase account
      await user.delete();
      await signOut();

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        debugPrint("Re-authentication required.");
      } else {
        debugPrint("Firebase error: ${e.code}");
      }
      return false;
    } catch (e) {
      debugPrint("Delete account error: $e");
      return false;
    }
  }


  /*Future<bool> deleteAccount() async {
    FirebaseAuth.instance.currentUser;
    try {
      if ( FirebaseAuth.instance.currentUser == null) return false;
      try {
        // Attempt to delete directly
        await _fireStore.collection('users').doc( FirebaseAuth.instance.currentUser?.uid).delete().then((onValue){
            FirebaseAuth.instance.currentUser!.delete().then((onValue){
            final google= GoogleSignIn();
            google.disconnect(); // Fully disconnects and clears session
          });
        });
        return true;
      } on FirebaseAuthException catch (e) {
        print(e);
        return false;
      }
    } catch (e) {
      print("Delete account error: $e");
      return false;
    }
  }*/


}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
