import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateAuthenticated extends AuthState {
  const AuthStateAuthenticated();
}

class AuthStateErrorAppeared extends AuthState {
  final String? error;
  const AuthStateErrorAppeared({this.error});
}

class AuthStateUnAuthenticated extends AuthState {
  // final String error;
  const AuthStateUnAuthenticated();
}
