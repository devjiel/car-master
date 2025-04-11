import 'package:car_master/models/entities/car_encyclopedia_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/car_encyclopedia_detail.freezed.dart';
part '../generated/models/car_encyclopedia_detail.g.dart';

@freezed
abstract class CarEncyclopediaDetail with _$CarEncyclopediaDetail {
  const factory CarEncyclopediaDetail({
    required CarEncyclopediaEntity car,
    required ManufacturerEntity manufacturer,
    required CountryEntity country,
    required BodyStyleEntity bodyStyle,
    List<CarEncyclopediaImage>? images,
  }) = _CarEncyclopediaDetail;

  factory CarEncyclopediaDetail.fromJson(Map<String, dynamic> json) => _$CarEncyclopediaDetailFromJson(json);
} 