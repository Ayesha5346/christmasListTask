import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techtiz/authentication/bloc/auth_bloc.dart';
import 'package:techtiz/authentication/views/signup_view.dart';
import 'package:techtiz/home/bloc/list_bloc.dart';
import 'package:techtiz/repositories/authentication_repo.dart';
import 'package:techtiz/repositories/christmas_list_repository.dart';
import '../../helper/common_helper_functions.dart';

void main() {
  final Finder signupNameFieldFinder = find.byKey(const Key('nameSignupField'));
  final Finder signupEmailFieldFinder =
      find.byKey(const Key('emailSignupField'));
  final Finder signupPasswordFieldFinder =
      find.byKey(const Key('passwordSignupField'));
  final Finder signupConfirmPasswordFieldFinder =
      find.byKey(const Key('confirmPasswordField'));
  final Finder signupButtonFinder = find.byKey(const Key('signupButtonKey'));
  final Finder homeScaffoldFinder = find.byKey(const Key('homeScaffold'));

  final mockFirestore = FakeFirebaseFirestore();
  final mockAuth = MockFirebaseAuth();

  Widget commonConfiguration() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            AuthenticationRepository(
                firebaseAuth: mockAuth, firebaseFirestore: mockFirestore),
          ),
        ),
        BlocProvider(
            create: (context) => ListBloc([],
                ChristmasListRepo(db: mockFirestore, firebaseAuth: mockAuth))),
      ],
      child: const MaterialApp(
        home: SignupPage(),
      ),
    );
  }

  testWidgets('Check basic structure', (tester) async {
    await tester.pumpWidget(commonConfiguration());

    expect(signupNameFieldFinder, findsOneWidget);
    expect(signupEmailFieldFinder, findsOneWidget);
    expect(signupPasswordFieldFinder, findsOneWidget);
    expect(signupConfirmPasswordFieldFinder, findsOneWidget);
    expect(signupButtonFinder, findsOneWidget);
  });

  testWidgets('Check tap on signup button', (tester) async {
    await tester.pumpWidget(commonConfiguration());
    await enterTextIntoField(tester,signupNameFieldFinder,'Hamza');
    await enterTextIntoField(tester,signupEmailFieldFinder,'hamzaali@gmail.com');
    await enterTextIntoField(tester,signupPasswordFieldFinder,'12345678');
    await enterTextIntoField(tester,signupConfirmPasswordFieldFinder,'12345678');
    await tester.tap(signupButtonFinder);
   await mockAuth.signInWithEmailAndPassword(email: 'hamzaali@gmail.com', password: '12345678');
    await tester.pump();
    // print(response);
    expect(homeScaffoldFinder, findsOneWidget);
  });
}
