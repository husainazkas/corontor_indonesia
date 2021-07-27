import 'package:json_annotation/json_annotation.dart';

part 'covid_province.g.dart';

@JsonSerializable(createToJson: false)
class CovidProvince {
  Attributes? attributes;

  CovidProvince(this.attributes);

  factory CovidProvince.fromJson(Map<String, dynamic> json) =>
      _$CovidProvinceFromJson(json);
}

@JsonSerializable(createToJson: false)
class Attributes {
  @JsonKey(name: 'FID')
  final int id;
  @JsonKey(name: 'Kode_Provi')
  final int provinceId;
  @JsonKey(name: 'Provinsi')
  final String province;
  @JsonKey(name: 'Kasus_Posi')
  final int active;
  @JsonKey(name: 'Kasus_Semb')
  final int recovered;
  @JsonKey(name: 'Kasus_Meni')
  final int deaths;

  Attributes(
    this.id,
    this.provinceId, {
    required this.province,
    required this.active,
    required this.recovered,
    required this.deaths,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);
}
