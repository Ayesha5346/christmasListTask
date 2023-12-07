import 'package:equatable/equatable.dart';
import '../models/list_model.dart';

sealed class ListEvent extends Equatable{
  @override
  List<Object?> get props => [];
}
final class ListAddEvent extends ListEvent{
  final ChristmasEntry? christmasListObject;
  ListAddEvent({this.christmasListObject});
}

final class ListUpdateStatus extends ListEvent{
  final ChristmasEntry? christmasListObject;
  final int? currentIndex;
  final String? status;
  ListUpdateStatus({this.christmasListObject,this.currentIndex, this.status});
}