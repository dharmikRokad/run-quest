import 'package:flutter_bloc/flutter_bloc.dart';

/// A generic Cubit that manages a single state value of type [T].
/// This is used to replace local [setState] calls for state flags like page indices, 
/// text obscurity, countdown values, etc.
class ValueCubit<T> extends Cubit<T> {
  ValueCubit(super.initialState);

  void update(T value) => emit(value);
}
