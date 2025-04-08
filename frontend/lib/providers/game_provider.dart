import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/car.dart';
import '../models/game_state.dart';
import '../repositories/car_repository.dart';


// Fournisseur d'état du jeu avec un état de chargement initial
final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  final carRepository = CarRepository();
  return GameNotifier(carRepository);
});


class GameNotifier extends StateNotifier<GameState> {
  final CarRepository _carRepository;
  
  GameNotifier(this._carRepository) : super(GameState(
    currentQuestionIndex: 0,
    score: 0,
    currentOptions: [],
    isAnswered: false,
    hasFinished: false,
    cars: [],
    isLoading: true, // Commencer avec l'état de chargement
  )) {
    _initGame();
  }

  List<String> _generateOptions(Car currentCar, List<Car> allCars) {
    if (allCars.length < 4) {
      // Si pas assez de voitures, répéter certaines options
      final options = [currentCar.answer];
      final otherAnswers = allCars
          .where((car) => car.id != currentCar.id)
          .map((car) => car.answer)
          .toList();
      
      options.addAll(otherAnswers);
      
      // Remplir jusqu'à 4 options
      while (options.length < 4) {
        options.add(otherAnswers.isNotEmpty ? otherAnswers[0] : currentCar.answer);
      }
      
      return options..shuffle();
    } else {
      final List<String> otherAnswers = allCars
          .where((car) => car.id != currentCar.id)
          .map((car) => car.answer)
          .toList()
        ..shuffle();
  
      final options = [currentCar.answer, ...otherAnswers.take(3)]..shuffle();
      return options;
    }
  }

  bool _isCorrectAnswer(String selectedAnswer, Car car) {
    return selectedAnswer == car.answer;
  }

  Future<void> _initGame() async {
    try {
      final cars = await _carRepository.getAllCars();
      
      if (cars.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }

      state = state.copyWith(
        cars: cars..shuffle(),
        isLoading: false, // Désactiver l'état de chargement
      );
      
      _generateOptionsForCurrentCar();
    } catch (e) {
      // En cas d'erreur, désactiver l'état de chargement
      state = state.copyWith(isLoading: false);
      print('Erreur lors de l\'initialisation du jeu: $e');
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
    
    // Si on est à la dernière question
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
    // Mettre en état de chargement pendant la réinitialisation
    state = state.copyWith(isLoading: true);
    
    try {
      final cars = await _carRepository.getAllCars();
      
      if (cars.isEmpty) {
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
      print('Erreur lors de la réinitialisation du jeu: $e');
    }
  }
} 