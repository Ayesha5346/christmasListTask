import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techtiz/authentication/bloc/auth_event.dart';
import 'package:techtiz/authentication/bloc/auth_state.dart';
import 'package:techtiz/repositories/authentication_repo.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository authRepository;
  AuthBloc(this.authRepository) : super(const AuthStateUnAuthenticated()) {
    on<AuthLoginPressed>(login);
    on<AuthSignupPressed>(signUp);
    on<AuthLogoutRequested>(logout);
  }

  void login(event, Emitter<AuthState> emit) async {
    emit(const AuthStateLoading());
    await authRepository
        .logInWithEmailAndPassword(email: event.email, password: event.password)
        .then((value) {
      emit(const AuthStateAuthenticated());
    }, onError: (error) {
      emit(AuthStateErrorAppeared(error: error));
      emit(const AuthStateUnAuthenticated());
    });
  }

  void signUp(event, Emitter<AuthState> emit) async {
    emit(const AuthStateLoading());
    await authRepository.addUser(event.email, event.name, event.password).then(
        (value) {
      emit(const AuthStateAuthenticated());
    }, onError: (error) {
      emit(AuthStateErrorAppeared(error: error));
      emit(const AuthStateUnAuthenticated());
    });
  }

  void logout(event, Emitter<AuthState> emit) async {
    emit(const AuthStateLoading());
    await authRepository.logOut().then((value) {
      emit(const AuthStateUnAuthenticated());
    }, onError: (error) {
      emit(AuthStateErrorAppeared(error: error));
    });
  }
}
