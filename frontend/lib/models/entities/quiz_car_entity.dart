import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/models/entities/quiz_car_entity.freezed.dart';
part '../../generated/models/entities/quiz_car_entity.g.dart';

@freezed
abstract class QuizCarEntityModel with _$QuizCarEntityModel {
  const factory QuizCarEntityModel({
    required String id,
    required String brand,
    required String model,
    @JsonKey(name: 'image_url') required String imageUrl,
    required String answer,
  }) = _QuizCarEntityModel;

  factory QuizCarEntityModel.fromJson(Map<String, dynamic> json) => _$QuizCarEntityModelFromJson(json);
} 