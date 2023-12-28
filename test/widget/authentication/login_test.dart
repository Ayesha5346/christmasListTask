import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techtiz/authentication/bloc/auth_bloc.dart';
import 'package:techtiz/authentication/views/login_view.dart';
import 'package:techtiz/home/bloc/list_bloc.dart';
import 'package:techtiz/repositories/authentication_repo.dart';
import 'package:techtiz/repositories/christmas_list_repository.dart';
import '../../helper/common_helper_functions.dart';
import '../../mocks/mock_firebase_auth.dart';

void main() {
  final Finder emailFieldFinder = find.byKey(const Key('loginEmailField'));
  final Finder passwordFieldFinder = find.byKey(const Key('loginPasswordField'));
  final Finder loginButtonFieldFinder = find.byKey(const Key('LoginButton'));
  final Finder richTextFieldFinder = find.byKey(const Key('noAccountTextWidget'));
  final Finder signupMainColumn = find.byKey(const Key('signupMainColumn'));
  final Finder homeScaffoldFinder = find.byKey(const Key('homeScaffold'));
  final Finder errorSnackbarTextFinder = find.byKey(const Key('ErrorTextKey'));
  final GlobalKey key = GlobalKey();
  final MyMockFirebaseAuth mymockAuth = MyMockFirebaseAuth();
  final mockFirestore = FakeFirebaseFirestore();
  final mockAuth = MockFirebaseAuth();
  Widget commonConfiguration() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            AuthenticationRepository(
                firebaseAuth: mymockAuth, firebaseFirestore: mockFirestore),
          ),
        ),
        BlocProvider(
            create: (context) => ListBloc([],
                ChristmasListRepo(db: mockFirestore, firebaseAuth: mockAuth))),
      ],
      child: Builder(
        key: key,
        builder: (context) {
          return const MaterialApp(
            home: LoginPage(),
          );
        }
      ),
    );
  }

  void fireOnTap(Finder finder, String text) {
    final Element element = finder.evaluate().single;
    final RenderParagraph paragraph = element.renderObject as RenderParagraph;
    // The children are the individual TextSpans which have GestureRecognizers
    paragraph.text.visitChildren((dynamic span) {
      if (span.text != text) return true; // continue iterating.

      (span.recognizer as TapGestureRecognizer).onTap!();
      return false; // stop iterating, we found the one.
    });
  }

  testWidgets('Test to check basic structure', (tester) async {
    await tester.pumpWidget(commonConfiguration());

    expect(emailFieldFinder, findsOneWidget);
    expect(passwordFieldFinder, findsOneWidget);
    expect(loginButtonFieldFinder, findsOneWidget);
    expect(richTextFieldFinder, findsOneWidget);
  });

  testWidgets('Error snackbar check when fields left empty', (tester) async {
    await tester.pumpWidget(commonConfiguration());
    await enterTextIntoField(tester,emailFieldFinder,'');
    await enterTextIntoField(tester,passwordFieldFinder,'');
    await tester.tap(loginButtonFieldFinder);
    await tester.pump();
    expect(errorSnackbarTextFinder, findsOneWidget);
  });
  testWidgets('Error snackbar check when email left empty', (tester) async {
    await tester.pumpWidget(commonConfiguration());
    await enterTextIntoField(tester,emailFieldFinder,'');
    await enterTextIntoField(tester,passwordFieldFinder,'12345678');
    await tester.tap(loginButtonFieldFinder);
    await tester.pump();
    expect(errorSnackbarTextFinder, findsOneWidget);
  });
  testWidgets('Error snackbar check when password left empty', (tester) async {
    await tester.pumpWidget(commonConfiguration());
    await enterTextIntoField(tester,emailFieldFinder,'hamzaali@gmail.com');
    await enterTextIntoField(tester,passwordFieldFinder,'');
    await tester.tap(loginButtonFieldFinder);
    await tester.pump();
    expect(errorSnackbarTextFinder, findsOneWidget);
  });
  testWidgets('Test to check login button', (tester) async {
    await tester.pumpWidget(commonConfiguration());
    // var currentContext = key.currentContext;
    await enterTextIntoField(tester,emailFieldFinder,'hamzaali@gmail.com');
    await enterTextIntoField(tester,passwordFieldFinder,'12345678');
    await tester.tap(loginButtonFieldFinder);
    await tester.pumpAndSettle();
    // mockAuth.signInWithEmailAndPassword(email: 'hamzaali@gmail.com', password: '12345678');
    // print(mockAuth.currentUser?.uid);
    expect(homeScaffoldFinder, findsOneWidget);
  });

  testWidgets('Test to check sign up page navigating', (tester) async {
    await tester.pumpWidget(commonConfiguration());
    fireOnTap(find.byKey(const Key('noAccountTextWidget')).first, 'Sign up');
    await tester.pumpAndSettle();

    expect(signupMainColumn, findsOneWidget);
    // print(isTapped);
  });
}
