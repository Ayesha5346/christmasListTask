import 'package:equatable/equatable.dart';
import '../models/list_model.dart';

class ListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ListInitialChecked extends ListEvent {
  ListInitialChecked();
}

final class ListItemAdded extends ListEvent {
  final ChristmasEntry? christmasListObject;
  ListItemAdded({this.christmasListObject});
}

final class ListItemStatusUpdated extends ListEvent {
  final ChristmasEntry? christmasListObject;
  final int? currentIndex;
  final String? status;
  ListItemStatusUpdated(
      {this.christmasListObject, this.currentIndex, this.status});
}
