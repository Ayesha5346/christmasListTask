
import 'package:equatable/equatable.dart';

class AuthEvent extends Equatable{
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthLoginPressed extends AuthEvent{
  final String email, password;
  const AuthLoginPressed({required this.email, required this.password});
}

final class AuthSignupPressed extends AuthEvent{
  final String name, email, password;
  const AuthSignupPressed({required this.name, required this.email, required this.password});
}

final class AuthLogoutRequested extends AuthEvent{
  const AuthLogoutRequested();
}