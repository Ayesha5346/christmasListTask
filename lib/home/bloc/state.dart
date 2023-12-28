import 'package:equatable/equatable.dart';
import '../models/list_model.dart';

class ListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ListStateInitial extends ListState {
  ListStateInitial();
}

class ListStateLoading extends ListState {
  ListStateLoading();
}

class ListStateSuccess extends ListState {
  final List<ChristmasEntry> kidsNameList;
  ListStateSuccess({required this.kidsNameList});
}

class ListStateFailure extends ListState {
  final String error;
  ListStateFailure({required this.error});
}
