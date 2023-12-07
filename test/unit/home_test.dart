import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techtiz/home/bloc/event.dart';
import 'package:techtiz/home/bloc/list_bloc.dart';
import 'package:techtiz/home/bloc/state.dart';
import 'package:techtiz/home/models/list_model.dart';

void main() {

  ChristmasEntry listItem =
      ChristmasEntry(name: 'Anya', country: 'USA', status: 'naughty');
  List<ChristmasEntry> mockList = [
    ChristmasEntry(name: 'Abdullah', country: 'Pakistan', status: 'nice'),
    ChristmasEntry(name: 'Anya', country: 'USA', status: 'naughty')
  ];
  ListBloc buildBloc() {
    return ListBloc([]);
  }
  ListBloc blocObject = ListBloc(mockList);
  group('construction', () {
    test('works properly', () {
      expect(buildBloc, returnsNormally);
    });
    test('check initial state', () {
      expect(buildBloc().state, equals(ListState()));
    });
  });

  group('List Events', () {
    blocTest('first item added',
        build: () => blocObject,
        act: (bloc) => bloc.add(ListAddEvent(
            christmasListObject: ChristmasEntry(
                name: 'Abdullah', country: 'Pakistan', status: 'nice'))),
        expect: () => [ListStateLoading(), ListStateSuccess(kidsNameList: mockList)]);
    blocTest('check if status updated in bloc list',
        build: ()=>blocObject,
        act: (bloc)=>bloc.add(ListUpdateStatus(christmasListObject: listItem,currentIndex: 1, status: 'bad')),
      expect: ()=>[
        ListStateLoading(),
        ListStateSuccess(kidsNameList: mockList),
      ]
    );

  });
}
