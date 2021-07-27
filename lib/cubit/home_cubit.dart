import 'package:corontor_indonesia/api/api_covid19.dart';
import 'package:corontor_indonesia/model/covid_national.dart';
import 'package:corontor_indonesia/model/covid_province.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'all_cubit_state.dart';

class HomeCubit extends Cubit<CubitState?> {
  HomeCubit([CubitState? initState]) : super(initState);

  final ApiCovid19 _apiCovid19 = ApiCovid19();

  List<CovidNational>? national;
  List<CovidProvince>? province;
  String? error;

  void fetchData() async {
    emit(CubitState.loading);
    final national = await _apiCovid19.getNational();
    if (national.error != null) {
      error = national.error;
      emit(CubitState.failed);
      return;
    }
    final province = await _apiCovid19.getProvince();
    if (province.error != null) {
      error = province.error;
      emit(CubitState.failed);
      return;
    }

    this.national = national.data;
    this.province = province.data;
    emit(CubitState.success);
  }
}
