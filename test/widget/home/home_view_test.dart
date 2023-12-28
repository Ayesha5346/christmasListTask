import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techtiz/authentication/bloc/auth_bloc.dart';

import 'package:techtiz/home/bloc/list_bloc.dart';
import 'package:techtiz/home/bloc/observer.dart';
import 'package:techtiz/home/views/home_view.dart';
import 'package:techtiz/repositories/authentication_repo.dart';
import 'package:techtiz/repositories/christmas_list_repository.dart';
import '../../mocks/firebase_mock.dart';
import '../../helper/common_helper_functions.dart';

class MockListBloc extends Mock implements ListBloc{}

void main() {
  setupFirebaseAuthMocks();
  final Finder scaffoldFinder = find.byKey(const Key('homeScaffold'));
  final Finder floatingButtonFinder = find.byKey(const Key('floatingButtonKey'));
  final Finder stackFinder = find.byKey(const Key('HomeParentStack'));
  final Finder logoutButtonFinder = find.byKey(const Key('LogoutButton'));
  final Finder mainColumnFinder = find.byKey(const Key('homeMainColumn'));
  final Finder titleTextFinder = find.byKey(const Key('homeHeading'));
  final Finder expandedLayoutFinder = find.byKey(const Key('listLayoutExpandedWidget'));
  final Finder blocBuilderFinder = find.byKey(const Key('blocBuilderForChristmasList'));
  final Finder blocListViewBuilderFinder = find.byKey(const Key('listViewBuilderKey'));
  final Finder addItemDialogueFinder = find.byKey(const Key('addDialogue'));
  final Finder updateStatusDialogueFinder = find.byKey(const Key('updateStatusDialogue'));
  final Finder addButtonFinder = find.byKey(const Key('addButtonKey'));
  final Finder statusButtonFinder = find.byKey(const Key('statusButtonKey0'));
  final Finder statusUpdateButtonFinder = find.byKey(const Key('updateStatusButton'));
  final Finder initialTextFinder = find.byKey(const Key('initialTextKey'));
  // final Finder errorTextFinder = find.byKey(const Key('ListErrorText'));
  // final Finder progressIndicatorFinder = find.byKey(const Key('loader'));
  //formFields
  // final Finder nameFieldFinder = find.byKey(const Key('nameFormFiled'));
  // final Finder countryFieldFinder = find.byKey(const Key('countryFormField'));
  // final Finder statusFieldFinder = find.byKey(const Key('statusFormField'));
  final Finder statusUpdateFormField = find.byKey(const Key('statusUpdateFiled'));
  final mockFirestore = FakeFirebaseFirestore();
  final mockAuth = MockFirebaseAuth();
  Bloc.observer = const ListBlocObserver();

  setUpAll(()async{
     await Firebase.initializeApp();
     mockAuth.signInWithEmailAndPassword(email: 'hamzaali@gmail.com', password: '12345678');
  });

  Widget commonConfiguration() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>AuthBloc(
          AuthenticationRepository(firebaseAuth: mockAuth, firebaseFirestore: mockFirestore),),),
        BlocProvider(create: (context)=> ListBloc([], ChristmasListRepo(db: mockFirestore, firebaseAuth: mockAuth))
        ),
      ],
      child: const MaterialApp(
          home: HomePage()),
    );
  }

  testWidgets('Check Basic Structure', (commonTester) async {
    await commonTester.pumpWidget(commonConfiguration());
    expect(scaffoldFinder, findsOneWidget);
    expect(floatingButtonFinder, findsOneWidget);
    expect(stackFinder,findsOneWidget);
    expect(logoutButtonFinder, findsOneWidget);
    expect(mainColumnFinder, findsOneWidget);
    expect(titleTextFinder, findsOneWidget);
    expect(expandedLayoutFinder, findsOneWidget);
    expect(blocBuilderFinder, findsOneWidget);
  });

  testWidgets('Test to check if AlertDialogue displays', (tester) async {
    await tester.pumpWidget(commonConfiguration());
    await tester.tap(floatingButtonFinder);
    await tester.pump();
    expect(addItemDialogueFinder, findsOneWidget);
  });
  group('Bloc adding to list tests', () {
    testWidgets('Bloc State Initial Text', (tester) async {
      await tester.pumpWidget(commonConfiguration());
      //bloc state initial
      expect(initialTextFinder,findsOneWidget);
    });
   //TODO: resolve progress indicator
    testWidgets('Bloc state change checking listview gets data added', (tester)async{
      await tester.pumpWidget(commonConfiguration());
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(addItemDialogueFinder, findsOneWidget);
      await tester.tap(addButtonFinder);
      await tester.pump(const Duration(milliseconds: 20));
      // expect(progressIndicatorFinder, findsOneWidget);
      expectLater(addItemDialogueFinder, findsNothing);
      expect(blocListViewBuilderFinder,findsOneWidget);
      expect(find.byKey(const  Key('ChristmasListBuilderTile')).first,findsOneWidget);
    });

    testWidgets('Test to update status', (tester)async{
      await tester.pumpWidget(commonConfiguration());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(addItemDialogueFinder, findsOneWidget);
      await tester.tap(addButtonFinder);
      await tester.pump(const Duration(milliseconds: 20));
      // expect((statusWidget as Text).data,'nice');
      await tester.tap(statusButtonFinder);
      await tester.pump();
      expect(updateStatusDialogueFinder, findsOneWidget);
      await enterTextIntoField(tester,statusUpdateFormField,'naughty');
      await tester.tap(statusUpdateButtonFinder);
      await tester.pump();
      final statusWidget = tester.element(find.byKey(const Key('statusTextKey0'))).widget ;
      expect((statusWidget as Text).data,'naughty');
    });
  });

}
