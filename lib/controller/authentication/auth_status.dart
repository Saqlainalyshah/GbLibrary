
import 'package:equatable/equatable.dart';

/// used equatable package to compare objects
/// login state
class LoginState extends Equatable{
  const LoginState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


/// loading state of login state
class LoginStateLoading extends LoginState{
  const LoginStateLoading();

  @override
  List<Object?> get props=>[];
}
/// successfully logged state
class LoginStateSuccess extends LoginState{
  const LoginStateSuccess();

  @override
  List<Object?> get props=>[];
}
/// error  state
class LoginStateError extends LoginState{
  final String error;

  const LoginStateError(this.error);
  @override
  List<Object?> get props=>[error];
}
