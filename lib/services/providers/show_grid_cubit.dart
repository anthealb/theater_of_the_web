import 'package:flutter_bloc/flutter_bloc.dart';

class ShowGridCubit extends Cubit<bool> {
  ShowGridCubit() : super(true);

  void toggle() => emit(!state);
}
