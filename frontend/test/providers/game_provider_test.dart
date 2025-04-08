import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:car_master/models/car.dart';
import 'package:car_master/providers/game_provider.dart';
import 'package:car_master/repositories/car_repository.dart';

// Classe Mock pour CarRepository
class MockCarRepository extends Mock implements CarRepository {}

void main() {
  // Liste de voitures de test
  final testCars = [
    const Car(
      id: '1',
      brand: 'Tesla',
      model: 'Model S',
      imagePath: 'assets/images/cars/tesla_model_s.jpg',
      answer: 'Tesla Model S',
    ),
    const Car(
      id: '2',
      brand: 'BMW',
      model: 'i8',
      imagePath: 'assets/images/cars/bmw_i8.jpg',
      answer: 'BMW i8',
    ),
    const Car(
      id: '3',
      brand: 'Audi',
      model: 'R8',
      imagePath: 'assets/images/cars/audi_r8.jpg',
      answer: 'Audi R8',
    ),
    const Car(
      id: '4',
      brand: 'Mercedes',
      model: 'AMG GT',
      imagePath: 'assets/images/cars/mercedes_amg_gt.jpg',
      answer: 'Mercedes AMG GT',
    ),
  ];

  group('GameNotifier with data', () {
    late GameNotifier gameNotifier;
    late MockCarRepository mockCarRepository;

    setUp(() async {
      mockCarRepository = MockCarRepository();
      
      // Configuration du mock pour retourner la liste de voitures
      when(() => mockCarRepository.getAllCars()).thenAnswer((_) async => testCars);
      
      gameNotifier = GameNotifier(mockCarRepository);
      
      // Attendre que l'initialisation asynchrone soit terminée
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('initial state is set correctly', () {
      // Vérifie que l'initialisation charge les voitures et génère les options
      expect(gameNotifier.state.cars.length, 4);
      expect(gameNotifier.state.currentOptions.length, 4);
      expect(gameNotifier.state.currentQuestionIndex, 0);
      expect(gameNotifier.state.score, 0);
      expect(gameNotifier.state.isAnswered, false);
      expect(gameNotifier.state.hasFinished, false);
      expect(gameNotifier.state.currentCar, isNotNull);
      
      // Vérifie que la méthode getAllCars a été appelée
      verify(() => mockCarRepository.getAllCars()).called(1);
    });

    test('answerQuestion with correct answer increases score', () {
      // Récupère la bonne réponse de la voiture actuelle
      final currentCar = gameNotifier.state.currentCar;
      expect(currentCar, isNotNull);
      
      final correctAnswer = currentCar!.answer;
      
      // Répond à la question
      gameNotifier.answerQuestion(correctAnswer);
      
      // Vérifie que le score a augmenté et que l'état a changé
      expect(gameNotifier.state.score, 1);
      expect(gameNotifier.state.isAnswered, true);
      expect(gameNotifier.state.selectedAnswer, correctAnswer);
    });

    test('answerQuestion with incorrect answer does not increase score', () {
      // Récupère la voiture actuelle
      final currentCar = gameNotifier.state.currentCar;
      expect(currentCar, isNotNull);
      
      // Trouve une réponse incorrecte
      final incorrectAnswer = gameNotifier.state.currentOptions
          .firstWhere((option) => option != currentCar!.answer);
      
      // Répond à la question
      gameNotifier.answerQuestion(incorrectAnswer);
      
      // Vérifie que le score n'a pas augmenté
      expect(gameNotifier.state.score, 0);
      expect(gameNotifier.state.isAnswered, true);
      expect(gameNotifier.state.selectedAnswer, incorrectAnswer);
    });

    test('answerQuestion does nothing if already answered', () {
      // Récupère la voiture actuelle
      final currentCar = gameNotifier.state.currentCar;
      expect(currentCar, isNotNull);
      
      // Répond d'abord à la question avec une réponse correcte
      final correctAnswer = currentCar!.answer;
      gameNotifier.answerQuestion(correctAnswer);
      expect(gameNotifier.state.score, 1);
      
      // Essaie de répondre à nouveau avec une réponse incorrecte
      final incorrectOption = gameNotifier.state.currentOptions
          .firstWhere((option) => option != correctAnswer);
      gameNotifier.answerQuestion(incorrectOption);
      
      // Le score ne devrait pas changer et la réponse sélectionnée devrait rester la même
      expect(gameNotifier.state.score, 1);
      expect(gameNotifier.state.selectedAnswer, correctAnswer);
    });

    test('nextQuestion moves to the next question', () {
      // Récupère la voiture actuelle
      final currentCar = gameNotifier.state.currentCar;
      expect(currentCar, isNotNull);
      
      // Répond à la question actuelle
      gameNotifier.answerQuestion(currentCar!.answer);
      
      // Passe à la question suivante
      gameNotifier.nextQuestion();
      
      // Vérifie que l'index a été incrémenté
      expect(gameNotifier.state.currentQuestionIndex, 1);
      expect(gameNotifier.state.isAnswered, false);
      
      // Vérifie que la voiture a changé
      final newCar = gameNotifier.state.currentCar;
      expect(newCar, isNotNull);
      expect(newCar!.id, isNot(equals(currentCar.id)));
    });

    test('hasFinished is set when reaching the last question', () {
      // Dans notre cas, avec 4 voitures de test, si on est à l'index 3, on est à la dernière question
      
      // Répond et passe à la question suivante jusqu'aux questions précédant la dernière
      for (int i = 0; i < testCars.length - 2; i++) {
        final car = gameNotifier.state.currentCar;
        expect(car, isNotNull);
        gameNotifier.answerQuestion(car!.answer);
        gameNotifier.nextQuestion();
      }
      
      // On devrait être à la question avant la dernière
      expect(gameNotifier.state.currentQuestionIndex, 2);
      expect(gameNotifier.state.hasFinished, false);
      
      // Aller à la dernière question
      final car = gameNotifier.state.currentCar;
      expect(car, isNotNull);
      gameNotifier.answerQuestion(car!.answer);
      gameNotifier.nextQuestion();
      
      // Maintenant on est à la dernière question
      expect(gameNotifier.state.currentQuestionIndex, 3);
      
      // Répond à la dernière question
      final lastCar = gameNotifier.state.currentCar;
      expect(lastCar, isNotNull);
      gameNotifier.answerQuestion(lastCar!.answer);
      
      // Tente de passer à la question suivante, mais hasFinished doit être true 
      // et l'index ne doit pas changer car on est déjà à la dernière
      gameNotifier.nextQuestion();
      expect(gameNotifier.state.hasFinished, true);
      expect(gameNotifier.state.currentQuestionIndex, 3);
    });

    test('resetGame resets the game state', () async {
      // Récupère la voiture actuelle
      final car = gameNotifier.state.currentCar;
      expect(car, isNotNull);
      
      // Joue un peu au jeu
      gameNotifier.answerQuestion(car!.answer);
      gameNotifier.nextQuestion();
      
      final nextCar = gameNotifier.state.currentCar;
      expect(nextCar, isNotNull);
      gameNotifier.answerQuestion(nextCar!.answer);
      
      // Réinitialiser la configuration du mock pour resetGame
      clearInteractions(mockCarRepository);
      
      // Configuration du mock pour retourner la liste de voitures pour resetGame
      when(() => mockCarRepository.getAllCars()).thenAnswer((_) async => testCars);
      
      // Réinitialise le jeu
      await gameNotifier.resetGame();
      
      // Vérifie que tout est réinitialisé
      expect(gameNotifier.state.currentQuestionIndex, 0);
      expect(gameNotifier.state.score, 0);
      expect(gameNotifier.state.isAnswered, false);
      expect(gameNotifier.state.hasFinished, false);
      expect(gameNotifier.state.currentOptions.length, 4);
      expect(gameNotifier.state.currentCar, isNotNull);
      
      // Vérifie que getAllCars a été appelé à nouveau
      verify(() => mockCarRepository.getAllCars()).called(1);
    });

    test('currentOptions always contains the correct answer', () {
      for (int i = 0; i < gameNotifier.state.cars.length - 1; i++) {
        // Vérifie que les options contiennent toujours la bonne réponse
        final car = gameNotifier.state.currentCar;
        expect(car, isNotNull);
        
        expect(
          gameNotifier.state.currentOptions.contains(car!.answer),
          true,
        );
        
        // Passe à la question suivante
        gameNotifier.answerQuestion(car.answer);
        gameNotifier.nextQuestion();
      }
      
      // Vérifie la dernière question aussi
      final lastCar = gameNotifier.state.currentCar;
      expect(lastCar, isNotNull);
      
      expect(
        gameNotifier.state.currentOptions.contains(lastCar!.answer),
        true,
      );
    });

    test('currentOptions has no duplicates', () {
      // Pour chaque question
      for (int i = 0; i < gameNotifier.state.cars.length - 1; i++) {
        // Vérifie qu'il n'y a pas de doublons dans les options
        final options = gameNotifier.state.currentOptions;
        final uniqueOptions = options.toSet().toList();
        expect(options.length, uniqueOptions.length);
        
        // Passe à la question suivante
        final car = gameNotifier.state.currentCar;
        expect(car, isNotNull);
        gameNotifier.answerQuestion(car!.answer);
        gameNotifier.nextQuestion();
      }
      
      // Vérifie la dernière question aussi
      final options = gameNotifier.state.currentOptions;
      final uniqueOptions = options.toSet().toList();
      expect(options.length, uniqueOptions.length);
    });
  });

  group('GameNotifier with empty repository', () {
    late GameNotifier gameNotifier;
    late MockCarRepository emptyMockCarRepository;

    setUp(() async {
      emptyMockCarRepository = MockCarRepository();
      
      // Configuration du mock pour retourner une liste vide
      when(() => emptyMockCarRepository.getAllCars()).thenAnswer((_) async => []);
      
      gameNotifier = GameNotifier(emptyMockCarRepository);
      
      // Attendre que l'initialisation asynchrone soit terminée
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('handles empty car list gracefully', () {
      // Vérifie que l'état initial est correctement initialisé même sans voitures
      expect(gameNotifier.state.cars.isEmpty, true);
      expect(gameNotifier.state.currentOptions.isEmpty, true);
      expect(gameNotifier.state.currentQuestionIndex, 0);
      expect(gameNotifier.state.score, 0);
      expect(gameNotifier.state.isAnswered, false);
      expect(gameNotifier.state.hasFinished, false);
      expect(gameNotifier.state.currentCar, isNull);
      
      // Vérifie que la méthode getAllCars a été appelée
      verify(() => emptyMockCarRepository.getAllCars()).called(1);
      
      // Les méthodes ne devraient pas planter sans voitures
      expect(() => gameNotifier.answerQuestion("test"), returnsNormally);
      expect(() => gameNotifier.nextQuestion(), returnsNormally);
      expect(() => gameNotifier.resetGame(), returnsNormally);
    });
  });
} 