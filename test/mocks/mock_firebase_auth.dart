import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:techtiz/repositories/authentication_repo.dart';

List mockUserList = [
  {
    'email': 'ayesha.rizwan@gmail.com',
    'password': '12345678',
    'uid': 'jcLP2ERPeBadI1YjwaEGElsC6PE3'
  },
  {
    'email': 'hamzaali@gmail.com',
    'password': '12345678',
    'uid': 'hpcUM41xx5MBBZrLsehThdd1Xmm1'
  },
];

class MyMockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!isValidEmail(email)) {
      throw LogInWithEmailAndPasswordFailure.fromCode('invalid-email');
    } else if (!checkUserAvailable(email, password)) {
      throw LogInWithEmailAndPasswordFailure.fromCode('invalid-credential');
    } else {
      // Simulate a successful login
      final userCredential = MockFirebaseAuth()
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      {required email, required name, required password}) {
    if (!isValidEmail(email)) {
      throw SignUpWithEmailAndPasswordFailure.fromCode('invalid-email');
    } else if (checkUserAlreadyExists(email)) {
      throw SignUpWithEmailAndPasswordFailure.fromCode('email-already-in-use');
    } else {
      final userCredential = MockFirebaseAuth()
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
  }
  @override
  // TODO: implement currentUser
  User? get currentUser {
    return MockFirebaseAuth().currentUser;
  }
  bool checkUserAvailable(
    String email,
    String password,
  ) {
    for (var user in mockUserList) {
      if (email == user['email'] && password == user['password']) {
        return true;
      }
    }
    return false;
  }

  bool checkUserAlreadyExists(String email) {
    for (var user in mockUserList) {
      if (user['email'] == email) {
        return true;
      }
    }
    return false;
  }

  bool isValidEmail(String email) {
    return email.contains('@');
  }
}
