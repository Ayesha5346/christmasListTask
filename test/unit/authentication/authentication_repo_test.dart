import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techtiz/repositories/authentication_repo.dart';
import '../../mocks/mock_firebase_auth.dart';

void main(){
  final auth = MockFirebaseAuth();
  final firestore = FakeFirebaseFirestore();
  final authRepository = AuthenticationRepository(firebaseAuth: auth, firebaseFirestore: firestore);

  test('test to signin',()async{
    var log=[];
    await authRepository.addUser('ayesha.rizwan578@gmail.com', 'Ayesha', '12345678').then(
        (value){
          log.add('success');
        },
    );
    expect(log, ['success']);
  });

  test('signin test to check invalid email format', ()async{
    var log=[];
    final fbauth = MyMockFirebaseAuth();
    await fbauth.signInWithEmailAndPassword(email: 'ayeshaRizwan', password: '12345678').then(
            (value) {
      log.add('success');
    },
    onError: (error){
      log.add(error);
    }
    );
    expect(log, ['Email is not valid or badly formatted.']);
  });




}