import 'package:booksexchange/controller/firebase_crud_operations/user_profile_crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../model/user_profile.dart';
import 'auth_providers.dart';


class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;
  final _fireStore = FirebaseFirestore.instance;
  Stream<User?> get authStateChange => _auth.authStateChanges();

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
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
