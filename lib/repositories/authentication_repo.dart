import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';

class SignUpWithEmailAndPasswordFailure implements Exception {
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        throw 'Email is not valid or badly formatted.';
      case 'user-disabled':
        throw 'This user has been disabled. Please contact support for help.';
      case 'email-already-in-use':
        throw 'An account already exists for that email.';
      case 'operation-not-allowed':
        throw 'Operation is not allowed.  Please contact support.';
      case 'weak-password':
        throw 'Please enter a stronger password.';
      default:
        throw 'An unknown exception occurred.';
    }
  }
}

class LogInWithEmailAndPasswordFailure implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        throw 'Email is not valid or badly formatted.';
      case 'user-disabled':
        throw 'This user has been disabled. Please contact support for help.';
      case 'user-not-found':
        throw 'Email is not found, please create an account.';
      case 'wrong-password':
        throw 'Incorrect password, please try again.';
      case 'invalid-credential':
        throw 'Incorrect password or email try again';
      default:
        throw 'An unknown exception occurred.';
    }
  }

  /// The associated error message.
  final String message;
}

class LogOutFailure implements Exception {}

class AuthenticationRepository {
  final dynamic firebaseAuth;
  final dynamic firebaseFirestore;
  AuthenticationRepository(
      {required this.firebaseAuth, required this.firebaseFirestore});
  User? user;
  String getUserId() {
    User localUser = firebaseAuth.currentUser;
    print('main repo checking user: ${localUser.uid}');
    return localUser.uid;
  }

  firebase_auth.User? getUser() {
    var localUser = firebaseAuth.currentUser;
    return localUser;
  }

  Future<void> addUserData(String? uid, String? name, String? email) async {
    try {
      await firebaseFirestore.collection('users').doc(uid).set({
        'user_id': uid,
        'name': name,
        'email': email,
      });
    } catch (e) {
      throw "Error adding user data: $e";
    }
  }

  Future<void> signUp(
      {required String email,
      required String name,
      required String password}) async {
    try {
      firebase_auth.UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> addUser(String email, String name, String password) async {
    await signUp(email: email, name: name, password: password);
    addUserData(user!.uid, name, user!.email);
  }

  Future logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (_) {
      throw 'Failed to logout';
    }
  }
}
