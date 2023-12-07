import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techtiz/home/bloc/state.dart';
import '../models/list_model.dart';
import 'event.dart';

class ListBloc extends Bloc<ListEvent, ListState>{
  ListBloc(this.res) : super(ListState()){
    on<ListAddEvent>(addItem);
    on<ListUpdateStatus>(updateStatus);
  }
  List<ChristmasEntry> res;

  void addItem(event, Emitter<ListState>emit){
    try{
      emit(ListStateLoading());
      res.add(event.christmasListObject);
      emit(ListStateSuccess( kidsNameList: res,));
    } catch(error){ //(error,stacktrace)
      emit(ListStateFailure(error: error.toString()));
    }
  }

  updateStatus(event, Emitter<ListState>emit){
    try{
      emit(ListStateLoading());

      event.christmasListObject.updateStatus(event.status);
      res[event.currentIndex] = event.christmasListObject;
      emit(ListStateSuccess( kidsNameList: res,));
    }catch(error){  //(error,stacktrace)
      emit(ListStateFailure(error: error.toString()));
    }
  }

}