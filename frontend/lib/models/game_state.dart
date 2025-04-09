import 'package:flutter/foundation.dart';
import 'car_entity.dart';

@immutable
class GameState {
  final int currentQuestionIndex;
  final int score;
  final List<String> currentOptions;
  final bool isAnswered;
  final String? selectedAnswer;
  final bool hasFinished;
  final List<CarEntityModel> cars;
  final bool isLoading;

  const GameState({
    required this.currentQuestionIndex,
    required this.score,
    required this.currentOptions,
    required this.isAnswered,
    this.selectedAnswer,
    required this.hasFinished,
    required this.cars,
    this.isLoading = false,
  });

  CarEntityModel? get currentCar => cars.isNotEmpty && currentQuestionIndex < cars.length 
      ? cars[currentQuestionIndex] 
      : null;
  int get totalQuestions => cars.length;
  bool get isCorrect => selectedAnswer == currentCar?.answer;

  GameState copyWith({
    int? currentQuestionIndex,
    int? score,
    List<String>? currentOptions,
    bool? isAnswered,
    String? selectedAnswer,
    bool? hasFinished,
    List<CarEntityModel>? cars,
    bool? isLoading,
  }) {
    return GameState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      currentOptions: currentOptions ?? this.currentOptions,
      isAnswered: isAnswered ?? this.isAnswered,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      hasFinished: hasFinished ?? this.hasFinished,
      cars: cars ?? this.cars,
      isLoading: isLoading ?? this.isLoading,
    );
  }
} 