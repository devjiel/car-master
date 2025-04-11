import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:car_master/models/quiz_car_entity.dart';
import 'package:car_master/providers/game_provider.dart';
import 'package:car_master/repositories/quiz_car_repository.dart';

class MockCarRepository extends Mock implements QuizCarRepository {}

void main() {

  final testCars = [
    const QuizCarEntityModel(
      id: '1',
      brand: 'Tesla',
      model: 'Model S',
      imageUrl: 'assets/images/cars/tesla_model_s.jpg',
      answer: 'Tesla Model S',
    ),
    const QuizCarEntityModel(
      id: '2',
      brand: 'BMW',
      model: 'i8',
      imageUrl: 'assets/images/cars/bmw_i8.jpg',
      answer: 'BMW i8',
    ),
    const QuizCarEntityModel(
      id: '3',
      brand: 'Audi',
      model: 'R8',
      imageUrl: 'assets/images/cars/audi_r8.jpg',
      answer: 'Audi R8',
    ),
    const QuizCarEntityModel(
      id: '4',
      brand: 'Mercedes',
      model: 'AMG GT',
      imageUrl: 'assets/images/cars/mercedes_amg_gt.jpg',
      answer: 'Mercedes AMG GT',
    ),
    const QuizCarEntityModel(
      id: '5',
      brand: 'Porsche',
      model: '911',
      imageUrl: 'assets/images/cars/porsche_911.jpg',
      answer: 'Porsche 911',
    ),
  ];

  group('GameNotifier with data', () {
    late GameNotifier gameNotifier;
    late MockCarRepository mockCarRepository;

    setUp(() async {
      mockCarRepository = MockCarRepository();
      

      when(() => mockCarRepository.getRandomCars()).thenAnswer((_) async => testCars);
      
      gameNotifier = GameNotifier(mockCarRepository);
      
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('initial state is set correctly', () {
      expect(gameNotifier.state.cars.length, 5);
      expect(gameNotifier.state.currentOptions.length, 5);
      expect(gameNotifier.state.currentQuestionIndex, 0);
      expect(gameNotifier.state.score, 0);
      expect(gameNotifier.state.isAnswered, false);
      expect(gameNotifier.state.hasFinished, false);
      expect(gameNotifier.state.currentCar, isNotNull);
      
      verify(() => mockCarRepository.getRandomCars()).called(1);
    });

    test('answerQuestion with correct answer increases score', () {
      final currentCar = gameNotifier.state.currentCar;
      expect(currentCar, isNotNull);
      
      final correctAnswer = currentCar!.answer;
      
      gameNotifier.answerQuestion(correctAnswer);
      
      expect(gameNotifier.state.score, 1);
      expect(gameNotifier.state.isAnswered, true);
      expect(gameNotifier.state.selectedAnswer, correctAnswer);
    });

    test('answerQuestion with incorrect answer does not increase score', () {
      final currentCar = gameNotifier.state.currentCar;
      expect(currentCar, isNotNull);
      
      final incorrectAnswer = gameNotifier.state.currentOptions
          .firstWhere((option) => option != currentCar!.answer);
      
      gameNotifier.answerQuestion(incorrectAnswer);
      
      expect(gameNotifier.state.score, 0);
      expect(gameNotifier.state.isAnswered, true);
      expect(gameNotifier.state.selectedAnswer, incorrectAnswer);
    });

    test('answerQuestion does nothing if already answered', () {
      final currentCar = gameNotifier.state.currentCar;
      expect(currentCar, isNotNull);
      
      final correctAnswer = currentCar!.answer;
      gameNotifier.answerQuestion(correctAnswer);
      expect(gameNotifier.state.score, 1);
      
      final incorrectOption = gameNotifier.state.currentOptions
          .firstWhere((option) => option != correctAnswer);
      gameNotifier.answerQuestion(incorrectOption);
      
      expect(gameNotifier.state.score, 1);
      expect(gameNotifier.state.selectedAnswer, correctAnswer);
    });

    test('nextQuestion moves to the next question', () {
      final currentCar = gameNotifier.state.currentCar;
      expect(currentCar, isNotNull);
      
      gameNotifier.answerQuestion(currentCar!.answer);
      
      gameNotifier.nextQuestion();
      
      expect(gameNotifier.state.currentQuestionIndex, 1);
      expect(gameNotifier.state.isAnswered, false);
      
      final newCar = gameNotifier.state.currentCar;
      expect(newCar, isNotNull);
      expect(newCar!.id, isNot(equals(currentCar.id)));
    });

    test('hasFinished is set when reaching the last question', () {
      // In order to reach the last question, we need to answer 5 questions
      
      // Answer and move to the next question until the previous question
      for (int i = 0; i < testCars.length - 2; i++) {
        final car = gameNotifier.state.currentCar;
        expect(car, isNotNull);
        gameNotifier.answerQuestion(car!.answer);
        gameNotifier.nextQuestion();
      }
      
      // We should be at the question before the last one
      expect(gameNotifier.state.currentQuestionIndex, 3);
      expect(gameNotifier.state.hasFinished, false);
      
      final car = gameNotifier.state.currentCar;
      expect(car, isNotNull);
      gameNotifier.answerQuestion(car!.answer);
      gameNotifier.nextQuestion();
      
      expect(gameNotifier.state.currentQuestionIndex, 4);
      
      // Now we are at the last question
      final lastCar = gameNotifier.state.currentCar;
      expect(lastCar, isNotNull);
      gameNotifier.answerQuestion(lastCar!.answer);
      
      // Try to move to the next question, but hasFinished should be true 
      // and the index should not change because we are already at the last question
      gameNotifier.nextQuestion();
      expect(gameNotifier.state.hasFinished, true);
      expect(gameNotifier.state.currentQuestionIndex, 4);
    });

    test('resetGame resets the game state', () async {
      final car = gameNotifier.state.currentCar;
      expect(car, isNotNull);
      
      gameNotifier.answerQuestion(car!.answer);
      gameNotifier.nextQuestion();
      
      final nextCar = gameNotifier.state.currentCar;
      expect(nextCar, isNotNull);
      gameNotifier.answerQuestion(nextCar!.answer);
      
      clearInteractions(mockCarRepository);
      
      when(() => mockCarRepository.getRandomCars()).thenAnswer((_) async => testCars);
      

      await gameNotifier.resetGame();
      
      expect(gameNotifier.state.currentQuestionIndex, 0);
      expect(gameNotifier.state.score, 0);
      expect(gameNotifier.state.isAnswered, false);
      expect(gameNotifier.state.hasFinished, false);
      expect(gameNotifier.state.currentOptions.length, 5);
      expect(gameNotifier.state.currentCar, isNotNull);
      
      verify(() => mockCarRepository.getRandomCars()).called(1);
    });

    test('currentOptions always contains the correct answer', () {
      for (int i = 0; i < gameNotifier.state.cars.length - 1; i++) {
        final car = gameNotifier.state.currentCar;
        expect(car, isNotNull);
        
        expect(
          gameNotifier.state.currentOptions.contains(car!.answer),
          true,
        );
        
        gameNotifier.answerQuestion(car.answer);
        gameNotifier.nextQuestion();
      }
      
      final lastCar = gameNotifier.state.currentCar;
      expect(lastCar, isNotNull);
      
      expect(
        gameNotifier.state.currentOptions.contains(lastCar!.answer),
        true,
      );
    });

    test('currentOptions has no duplicates', () {
      for (int i = 0; i < gameNotifier.state.cars.length - 1; i++) {
        final options = gameNotifier.state.currentOptions;
        final uniqueOptions = options.toSet().toList();
        expect(options.length, uniqueOptions.length);
        
        final car = gameNotifier.state.currentCar;
        expect(car, isNotNull);
        gameNotifier.answerQuestion(car!.answer);
        gameNotifier.nextQuestion();
      }
      
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
      
      when(() => emptyMockCarRepository.getRandomCars()).thenAnswer((_) async => []);
      
      gameNotifier = GameNotifier(emptyMockCarRepository);
      
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('handles empty car list gracefully', () {
      expect(gameNotifier.state.cars.isEmpty, true);
      expect(gameNotifier.state.currentOptions.isEmpty, true);
      expect(gameNotifier.state.currentQuestionIndex, 0);
      expect(gameNotifier.state.score, 0);
      expect(gameNotifier.state.isAnswered, false);
      expect(gameNotifier.state.hasFinished, false);
      expect(gameNotifier.state.currentCar, isNull);
      
      verify(() => emptyMockCarRepository.getRandomCars()).called(1);
      
      expect(() => gameNotifier.answerQuestion("test"), returnsNormally);
      expect(() => gameNotifier.nextQuestion(), returnsNormally);
      expect(() => gameNotifier.resetGame(), returnsNormally);
    });
  });
} 