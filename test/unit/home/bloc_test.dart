import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techtiz/home/bloc/event.dart';
import 'package:techtiz/home/bloc/list_bloc.dart';
import 'package:techtiz/home/bloc/state.dart';
import 'package:techtiz/home/models/list_model.dart';
import 'package:techtiz/repositories/christmas_list_repository.dart';

void main() {
  final mockFirestore = FakeFirebaseFirestore();
  final mockAuth = MockFirebaseAuth();

  ChristmasEntry listItem =
      ChristmasEntry(name: 'Anya', country: 'USA', status: 'naughty');
  List<ChristmasEntry> mockList = [
    ChristmasEntry(name: 'Abdullah', country: 'Pakistan', status: 'nice'),
    ChristmasEntry(name: 'Anya', country: 'USA', status: 'naughty')
  ];
  ListBloc buildBloc() {
    return ListBloc([], ChristmasListRepo(db: mockFirestore, firebaseAuth: mockAuth));
  }
  ListBloc blocObject = ListBloc(mockList, ChristmasListRepo(db: mockFirestore, firebaseAuth: mockAuth));
  group('construction', () {
    test('works properly', () {
      expect(buildBloc, returnsNormally);
    });
    test('check initial state', () {
      expect(buildBloc().state, equals(ListStateInitial()));
    });
  });

  group('List Events', () {
    blocTest('first item added',
        build: () => blocObject,
        act: (bloc) => bloc.add(ListItemAdded(
            christmasListObject: ChristmasEntry(
                name: 'Abdullah', country: 'Pakistan', status: 'nice'))),
        expect: () => [ListStateLoading(), ListStateSuccess(kidsNameList: mockList)]);
    blocTest('check if status updated in bloc list',
        build: ()=>blocObject,
        act: (bloc)=>bloc.add(ListItemStatusUpdated(christmasListObject: listItem,currentIndex: 1, status: 'bad')),
      expect: ()=>[
        ListStateLoading(),
        ListStateSuccess(kidsNameList: mockList),
      ]
    );

  });
}
