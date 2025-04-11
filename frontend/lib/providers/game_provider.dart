import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/entities/quiz_car_entity.dart';
import '../models/game_state.dart';
import '../repositories/quiz_car_repository.dart';
import '../services/supabase_service.dart';

// Game state provider with initial loading state
final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  final carRepository = QuizCarRepository(supabase: SupabaseService.client);
  return GameNotifier(carRepository);
});

const kCarsPerQuestion = 5;

class GameNotifier extends StateNotifier<GameState> {
  final QuizCarRepository _carRepository;
  
  GameNotifier(this._carRepository) : super(GameState(
    currentQuestionIndex: 0,
    score: 0,
    currentOptions: [],
    isAnswered: false,
    hasFinished: false,
    cars: [],
    isLoading: true, // Start with loading state
  )) {
    _initGame();
  }

  List<String> _generateOptions(QuizCarEntityModel currentCar, List<QuizCarEntityModel> allCars) {
    if (allCars.length < kCarsPerQuestion) {
      // If not enough cars, repeat some options
      final options = [currentCar.answer];
      final otherAnswers = allCars
          .where((car) => car.id != currentCar.id)
          .map((car) => car.answer)
          .toList();
      
      options.addAll(otherAnswers);
      
      // Fill up to 4 options
      while (options.length < kCarsPerQuestion) {
        options.add(otherAnswers.isNotEmpty ? otherAnswers[0] : currentCar.answer);
      }
      
      return options..shuffle();
    } else {
      final List<String> otherAnswers = allCars
          .where((car) => car.id != currentCar.id)
          .map((car) => car.answer)
          .toList()
        ..shuffle();
  
      final options = [currentCar.answer, ...otherAnswers.take(kCarsPerQuestion - 1)]..shuffle();
      return options;
    }
  }

  bool _isCorrectAnswer(String selectedAnswer, QuizCarEntityModel car) {
    return selectedAnswer == car.answer;
  }

  Future<void> _initGame() async {
    try {
      final cars = await _carRepository.getRandomCars();
      
      if (cars.isEmpty || cars.length < kCarsPerQuestion) {
        state = state.copyWith(isLoading: false);
        return;
      }

      state = state.copyWith(
        cars: cars..shuffle(),
        isLoading: false, // Disable loading state
      );
      
      _generateOptionsForCurrentCar();
    } catch (e) {
      // In case of error, disable loading state
      state = state.copyWith(isLoading: false);
      print('Error during game initialization: $e');
    }
  }

  void _generateOptionsForCurrentCar() {
    if (state.cars.isEmpty || state.currentCar == null) return;
    
    final options = _generateOptions(state.currentCar!, state.cars);
    state = state.copyWith(currentOptions: options);
  }

  void answerQuestion(String selectedAnswer) {
    if (state.isAnswered || state.cars.isEmpty || state.currentCar == null) return;
    
    final isCorrect = _isCorrectAnswer(selectedAnswer, state.currentCar!);
    
    state = state.copyWith(
      isAnswered: true,
      selectedAnswer: selectedAnswer,
      score: isCorrect ? state.score + 1 : state.score,
    );
  }

  void nextQuestion() {
    if (!state.isAnswered || state.cars.isEmpty || state.currentCar == null) return;
    
    // If we're at the last question
    if (state.currentQuestionIndex >= state.cars.length - 1) {
      state = state.copyWith(hasFinished: true);
      return;
    }
    
    state = state.copyWith(
      currentQuestionIndex: state.currentQuestionIndex + 1,
      isAnswered: false,
      selectedAnswer: null,
    );
    
    _generateOptionsForCurrentCar();
  }
  
  Future<void> resetGame() async {
    // Set loading state during reset
    state = state.copyWith(isLoading: true);
    
    try {
      final cars = await _carRepository.getRandomCars();
      
      if (cars.isEmpty || cars.length < kCarsPerQuestion) {
        state = state.copyWith(isLoading: false);
        return;
      }
      
      state = GameState(
        currentQuestionIndex: 0,
        score: 0,
        currentOptions: [],
        isAnswered: false,
        hasFinished: false,
        cars: cars..shuffle(),
        isLoading: false,
      );
      
      _generateOptionsForCurrentCar();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error during game reset: $e');
    }
  }
} 