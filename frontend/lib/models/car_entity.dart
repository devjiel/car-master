import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/car_entity.freezed.dart';
part '../generated/models/car_entity.g.dart';

@freezed
abstract class CarEntityModel with _$CarEntityModel {
  const factory CarEntityModel({
    required int id,
    required String brand,
    required String model,
    @JsonKey(name: 'image_path') required String imagePath,
    required String answer,
  }) = _CarEntityModel;

  factory CarEntityModel.fromJson(Map<String, dynamic> json) => _$CarEntityModelFromJson(json);
} 