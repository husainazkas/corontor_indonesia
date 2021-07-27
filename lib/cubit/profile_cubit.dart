import 'package:flutter_bloc/flutter_bloc.dart';

import 'all_cubit_state.dart';

typedef ProfileTask = Future<void> Function();

class ProfileCubit extends Cubit<CubitState?> {
  ProfileCubit([CubitState? initState]) : super(initState);

  Object? error;

  void callFunction(ProfileTask task) async {
    emit(CubitState.loading);
    try {
      await task();
    } catch (e) {
      print(e);
      error = e;
      emit(CubitState.failed);
      return;
    }
    emit(CubitState.success);
  }
}
