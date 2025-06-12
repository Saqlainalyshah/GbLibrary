import 'package:booksexchange/controller/firebase_crud_operations/user_profile_crud.dart';
import 'package:booksexchange/model/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';

final loginControllerProvider=Provider<AuthRepository>((ref)=> AuthRepository(FirebaseAuth.instance));
final currentUserProvider = StreamProvider<User?>((ref) async* {
  // Delay the stream for 2 seconds
  await Future.delayed(Duration(seconds: 2));

  // Emit the authentication state after the delay
  yield* ref.read(loginControllerProvider).authStateChange;
});


final userUIDProvider=Provider<User?>((ref)=> FirebaseAuth.instance.currentUser);

final userProfileDataProvider = StreamProvider.family<UserProfile, String>((ref, uid) async* {
  UserProfile userProfile = UserProfile(name: '', email: '');
  final result = await ref.watch(firebaseCRUDProvider).getDoc('users', uid);
  if (result != null && result.exists) {
    final doc = result.data();
    yield UserProfile.fromJson(doc!);
  } else {
    yield userProfile; // Yield the default profile instead of returning it
  }
});

final userProfileProvider = FutureProvider.family<UserProfile?, String>((ref, uid) async {
  DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
  await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (documentSnapshot.exists) {
    final data = documentSnapshot.data();
    return data != null ? UserProfile.fromJson(data) : null;
  } else {
    return null;
  }
});