// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'covid_province.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CovidProvince _$CovidProvinceFromJson(Map<String, dynamic> json) {
  return CovidProvince(
    json['attributes'] == null
        ? null
        : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
  );
}

Attributes _$AttributesFromJson(Map<String, dynamic> json) {
  return Attributes(
    json['FID'] as int,
    json['Kode_Provi'] as int,
    province: json['Provinsi'] as String,
    active: json['Kasus_Posi'] as int,
    recovered: json['Kasus_Semb'] as int,
    deaths: json['Kasus_Meni'] as int,
  );
}
