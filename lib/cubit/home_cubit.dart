import 'package:corontor_indonesia/api/api_covid19.dart';
import 'package:corontor_indonesia/model/covid_national.dart';
import 'package:corontor_indonesia/model/covid_province.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'all_cubit_state.dart';

class HomeCubit extends Cubit<CubitState?> {
  HomeCubit([CubitState? initState]) : super(initState);

  final ApiCovid19 _apiCovid19 = ApiCovid19();

  List<CovidNational>? _national;
  List<CovidProvince>? _province;
  String? nationalErr;
  String? provinceErr;

  List<CovidNational>? get national {
    if (nationalErr != null) return null;
    return _national;
  }

  List<CovidProvince>? get province {
    if (provinceErr != null) return null;
    return _province;
  }

  void fetchData() async {
    emit(CubitState.loading);
    final national = await _apiCovid19.getNational();
    nationalErr = national.error;

    final province = await _apiCovid19.getProvince();
    provinceErr = province.error;

    if (nationalErr != null && provinceErr != null) {
      emit(CubitState.failed);
      return;
    }

    this._national = national.data;
    this._province = province.data;
    emit(CubitState.success);
  }
}
