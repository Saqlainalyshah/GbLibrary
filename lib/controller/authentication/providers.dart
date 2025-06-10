import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';
import 'auth_status.dart';
import 'login_controller.dart';

final loginControllerProvider= StateNotifierProvider<LoginController,LoginState>((ref)=>LoginController(ref));
final authRepositoryProvider=Provider<AuthRepository>((ref)=> AuthRepository(FirebaseAuth.instance));

final userProvider = StreamProvider<User?>((ref) async* {
  // Delay the stream for 2 seconds
  await Future.delayed(Duration(seconds: 2));

  // Emit the authentication state after the delay
  ref.read(authRepositoryProvider).authStateChange;
});