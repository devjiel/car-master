import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/models/entities/car_encyclopedia_entity.freezed.dart';
part '../../generated/models/entities/car_encyclopedia_entity.g.dart';


@freezed
abstract class ManufacturerEntity with _$ManufacturerEntity {
  const factory ManufacturerEntity({
    required String id,
    required String name,
    required String country,
    @JsonKey(name: 'logo_url')
    String? logoUrl,
    required String description,
    @JsonKey(name: 'founding_year')
    int? foundingYear,
  }) = _ManufacturerEntity;

  factory ManufacturerEntity.fromJson(Map<String, dynamic> json) => _$ManufacturerEntityFromJson(json);
}

@freezed
abstract class CountryEntity with _$CountryEntity {
  const factory CountryEntity({
    required String id,
    required String name,
    required String code,
    @JsonKey(name: 'flag_url')
    String? flagUrl,
  }) = _CountryEntity;

  factory CountryEntity.fromJson(Map<String, dynamic> json) => _$CountryEntityFromJson(json);
}

@freezed
abstract class BodyStyleEntity with _$BodyStyleEntity {
  const factory BodyStyleEntity({
    required String id,
    required String name,
    required String description,
    @JsonKey(name: 'icon_url')
    String? iconUrl,
  }) = _BodyStyleEntity;

  factory BodyStyleEntity.fromJson(Map<String, dynamic> json) => _$BodyStyleEntityFromJson(json);
}

@freezed
abstract class CarEncyclopediaEntity with _$CarEncyclopediaEntity {
  const factory CarEncyclopediaEntity({
    required String id,
    required String name,
    @JsonKey(name: 'short_description')
    required String shortDescription,
    @JsonKey(name: 'default_image_url')
    required String defaultImageUrl,
    required String description,
    @JsonKey(name: 'manufacturer_id')
    required String manufacturerId,
    required String year,
    @JsonKey(name: 'country_id')
    required String countryId,
    @JsonKey(name: 'designer_names')
    List<String>? designerNames,
    @JsonKey(name: 'body_style_id')
    required String bodyStyleId,
    required String engine,
    required String power,
    required String torque,
    required String drivetrain,
    required String acceleration,
    @JsonKey(name: 'top_speed')
    required String topSpeed,
    required String dimensions,
    required String weight,
    @JsonKey(name: 'additional_specs', defaultValue: {})
    required Map<String, String> additionalSpecs,
    required String history,
    @JsonKey(name: 'notable_facts', defaultValue: [])
    required List<String> notableFacts,
    @JsonKey(defaultValue: [])
    required List<String> awards,
  }) = _CarEncyclopediaEntity;

  factory CarEncyclopediaEntity.fromJson(Map<String, dynamic> json) => _$CarEncyclopediaEntityFromJson(json);
}

@freezed
abstract class CarEncyclopediaImage with _$CarEncyclopediaImage {
  const factory CarEncyclopediaImage({
    required String id,
    @JsonKey(name: 'encyclopedia_entry_id')
    required String encyclopediaEntryId,
    @JsonKey(name: 'image_url')
    required String imageUrl,
    String? caption,
    @JsonKey(name: 'display_order')
    required int displayOrder,
  }) = _CarEncyclopediaImage;

  factory CarEncyclopediaImage.fromJson(Map<String, dynamic> json) => _$CarEncyclopediaImageFromJson(json);
}
