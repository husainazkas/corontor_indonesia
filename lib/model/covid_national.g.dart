// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'covid_national.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CovidNational _$CovidNationalFromJson(Map<String, dynamic> json) {
  return CovidNational(
    name: json['name'] as String,
    active: CovidNational.toInt(json['positif'] as String),
    recovered: CovidNational.toInt(json['sembuh'] as String),
    deaths: CovidNational.toInt(json['meninggal'] as String),
  );
}
