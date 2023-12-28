import 'package:flutter_bloc/flutter_bloc.dart';

class ListBlocObserver extends BlocObserver {
  /// {@macro counter_observer}
  const ListBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    // ignore: avoid_print
    print('Time: ${DateTime.now()} , ${bloc.runtimeType} $change');
  }
}
