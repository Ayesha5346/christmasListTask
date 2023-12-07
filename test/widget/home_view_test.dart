import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techtiz/bloc/event.dart';
import 'package:techtiz/bloc/list_bloc.dart';
import 'package:techtiz/models/list_model.dart';
import 'package:techtiz/views/home_view.dart';
import '../helper/bloc_list_helper.dart';

void main() {
  final Finder scaffoldFinder = find.byKey(const Key('homeScaffold'));
  final Finder floatingButtonFinder = find.byKey(const Key('floatingButtonKey'));
  final Finder mainColumnFinder = find.byKey(const Key('homeMainColumn'));
  final Finder titleTextFinder = find.byKey(const Key('homeHeading'));
  final Finder expandedLayoutFinder = find.byKey(const Key('listLayoutExpandedWidget'));
  final Finder blocBuilderFinder = find.byKey(const Key('blocBuilderForChristmasList'));
  final Finder blocListViewBuilderFinder = find.byKey(const Key('listViewBuilderKey'));
  final Finder addItemDialogueFinder = find.byKey(const Key('addDialogue'));
  final Finder updateStatusDialogueFinder = find.byKey(const Key('updateStatusDialogue'));
  final Finder addButtonFinder = find.byKey(const Key('addButtonKey'));
  final Finder statusButtonFinder = find.byKey(const Key('statusButtonKey0'));
  final Finder statsUpdateButtonFinder = find.byKey(const Key('updateStatusButton'));
  final GlobalKey key = GlobalKey();
  Widget commonConfiguration() {
    return MaterialApp(
        home: BlocProvider(
            create: (_) => ListBloc(),
            child: Builder(
                key: key,
                builder: (context) {
                  return const HomePage();
                })));
  }

  testWidgets('Check Basic Structure', (commonTester) async {
    await commonTester.pumpWidget(commonConfiguration());
    expect(scaffoldFinder, findsOneWidget);
    expect(floatingButtonFinder, findsOneWidget);
    expect(mainColumnFinder, findsOneWidget);
    expect(titleTextFinder, findsOneWidget);
    expect(expandedLayoutFinder, findsOneWidget);
    expect(blocBuilderFinder, findsOneWidget);
    // expect(blocListViewBuilderFinder , findsOneWidget);
  });

  testWidgets('Test to check if AlertDialogue displays', (tester) async {
    await tester.pumpWidget(commonConfiguration());
    await tester.tap(floatingButtonFinder);
    await tester.pump();
    expect(addItemDialogueFinder, findsOneWidget);
  });

  testWidgets('Test to add item in Bloc list', (tester) async {
    await tester.pumpWidget(commonConfiguration());
    ListBloc blocObject = ListBloc();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    expect(addItemDialogueFinder, findsOneWidget);
    await tester.tap(addButtonFinder);
    ChristmasEntry listItem =
        ChristmasEntry(name: 'Abdullah', country: 'Pakistan', status: 'nice');
    blocObject.add(ListAddEvent(christmasListObject: listItem));
    await tester.pump();
    expect(blocObject.res.length, 1);
    expect(addItemDialogueFinder, findsNothing);
  });

  // blocTest<ListBloc,ListState>('bloc test',
  //     build: ()=>ListBloc(),
  //     act:(bloc)=>bloc.add(ListAddEvent(christmasListObject: ChristmasEntry(name: 'Abdullah', country: 'Pakistan', status: 'nice'))),
  //     expect: ()=> [
  //       ListStateLoading(),
  //       ListStateSuccess(kidsNameList: [])
  //     ]
  // );
  testWidgets('Test to check if ListView is being populated', (tester) async {
    await tester.pumpWidget(commonConfiguration());
    final blocContext = key.currentContext;
    BlocListHelper helper = BlocListHelper();
    for (int i = 0; i < helper.nameList.length; i++) {
      blocContext
          ?.read<ListBloc>()
          .add(ListAddEvent(christmasListObject: helper.nameList[i]));
      await tester.pump();
    }
    // expect(_bloc.res.length , 3);
    expect(blocBuilderFinder,
        findsOneWidget);
    expect(blocListViewBuilderFinder, findsOneWidget);
  });

  // update Status test
  testWidgets('Test to check status update dialogue', (tester) async {
    await tester.pumpWidget(commonConfiguration());
    final blocContext = key.currentContext;
    ChristmasEntry listItem =
        ChristmasEntry(name: 'Amina', country: 'Philipines', status: 'nice');
    blocContext?.read<ListBloc>().add(ListAddEvent(
          christmasListObject: listItem,
        ));
    await tester.pump();
    await tester.tap(statusButtonFinder);
    await tester.pump();
    expect(updateStatusDialogueFinder, findsOneWidget);
    await tester.tap(statsUpdateButtonFinder);
    blocContext?.read<ListBloc>().add(ListUpdateStatus(
        christmasListObject: listItem, currentIndex: 0, status: 'naughty'));
    await tester.pump();
    expect(updateStatusDialogueFinder, findsNothing);
    expect(blocContext?.read<ListBloc>().res[0].status, 'naughty');
  });
}
