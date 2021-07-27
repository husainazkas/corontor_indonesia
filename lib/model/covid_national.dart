import 'package:json_annotation/json_annotation.dart';

part 'covid_national.g.dart';

@JsonSerializable(createToJson: false)
class CovidNational {
  final String name;
  @JsonKey(name: 'positif', fromJson: toInt)
  final int active;
  @JsonKey(name: 'sembuh', fromJson: toInt)
  final int recovered;
  @JsonKey(name: 'meninggal', fromJson: toInt)
  final int deaths;

  CovidNational({
    required this.name,
    required this.active,
    required this.recovered,
    required this.deaths,
  });

  factory CovidNational.fromJson(Map<String, dynamic> json) =>
      _$CovidNationalFromJson(json);

  static int toInt(String value) => int.tryParse(value.replaceAll(',', ''))!;
}
