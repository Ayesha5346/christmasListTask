import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techtiz/home/bloc/state.dart';
import 'package:techtiz/repositories/christmas_list_repository.dart';
import '../models/list_model.dart';
import 'event.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc(this.res, this.repository) : super(ListStateInitial()) {
    on<ListItemAdded>(addItem);
    on<ListItemStatusUpdated>(updateStatus);
    on<ListInitialChecked>(checkList);
  }
  List<ChristmasEntry> res;
  ChristmasListRepo repository;
  void checkList(event, Emitter<ListState> emit) async {
    res = await repository.getDataFromFirestore();
    res.isEmpty == false ? emit(ListStateSuccess(kidsNameList: res)) : null;
  }

  void addItem(event, Emitter<ListState> emit) async {
    emit(ListStateLoading());
    await repository.addDataToFireStore(event.christmasListObject).then(
        (value) async {
      res = await repository.getDataFromFirestore();
      emit(ListStateSuccess(
        kidsNameList: res,
      ));
    }, onError: (error) {
      emit(ListStateFailure(error: error.toString()));
    });
  }

  void updateStatus(event, Emitter<ListState> emit) async {
    try {
      emit(ListStateLoading());

      await repository
          .updateStatusFirestoreList(event.currentIndex, event.status)
          .then((value) async {
        res = await repository.getDataFromFirestore();
        emit(ListStateSuccess(
          kidsNameList: res,
        ));
      });
    } catch (error) {
      //(error,stacktrace)
      emit(ListStateFailure(error: error.toString()));
    }
  }
}
