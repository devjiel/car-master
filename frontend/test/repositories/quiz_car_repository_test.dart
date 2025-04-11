import 'package:car_master/models/entities/quiz_car_entity.dart';
import 'package:car_master/repositories/quiz_car_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late SupabaseClient mockSupabase;
  late MockSupabaseHttpClient mockHttpClient;
  late QuizCarRepository carRepository;

  setUp(() {
    mockHttpClient = MockSupabaseHttpClient();
    mockSupabase = SupabaseClient(
      'https://mock.supabase.co',
      'fakeAnonKey',
      httpClient: mockHttpClient,
    );
    carRepository = QuizCarRepository(supabase: mockSupabase);
  });

  tearDown(() {
    mockHttpClient.reset();
  });

  group('getRandomCars', () {
    test('should return list of cars when data is valid', () async {
      // Arrange
      final mockCars = [
        {
          'id': '1',
          'brand': 'Ferrari',
          'model': 'F40',
          'image_url': 'https://example.com/f40.jpg',
          'answer': 'Ferrari F40'
        },
        {
          'id': '2',
          'brand': 'Porsche',
          'model': '911',
          'image_url': 'https://example.com/911.jpg',
          'answer': 'Porsche 911'
        }
      ];

      await mockSupabase.from('quiz_cars').insert(mockCars);

      // Act
      final result = await carRepository.getRandomCars();

      // Assert
      expect(result.length, 2);
      expect(result[0], isA<QuizCarEntityModel>());
      expect(result[0].id, '1');
      expect(result[0].brand, 'Ferrari');
      expect(result[0].model, 'F40');
      expect(result[0].imageUrl, 'https://example.com/f40.jpg');
      expect(result[1], isA<QuizCarEntityModel>());
      expect(result[1].id, '2');
      expect(result[1].brand, 'Porsche');
      expect(result[1].model, '911');
      expect(result[1].imageUrl, 'https://example.com/911.jpg');
    });

    test('should return empty list when error occurs', () async {
      // Arrange
      mockHttpClient = MockSupabaseHttpClient(
        postgrestExceptionTrigger: (schema, table, data, type) {
          throw PostgrestException(
            message: 'Error fetching data',
            code: '500',
          );
        },
      );
      mockSupabase = SupabaseClient(
        'https://mock.supabase.co',
        'fakeAnonKey',
        httpClient: mockHttpClient,
      );
      carRepository = QuizCarRepository(supabase: mockSupabase);

      // Act
      final result = await carRepository.getRandomCars();

      // Assert
      expect(result, isEmpty);
    });

    test('should skip malformed data and return valid cars only', () async {
      // Arrange
      final mockCars = [
        {
          'id': '1',
          'brand': 'Ferrari',
          'model': 'F40',
          'image_url': 'https://example.com/f40.jpg',
          'answer': 'Ferrari F40'
        },
        {
          'id': '2',
          'brand': null, // Invalid data
          'model': '911',
          'image_url': 'https://example.com/911.jpg',
          'answer': 'Porsche 911'
        }
      ];

      await mockSupabase.from('quiz_cars').insert(mockCars);

      // Act
      final result = await carRepository.getRandomCars();

      // Assert
      expect(result.length, 1);
      expect(result[0].brand, 'Ferrari');
      expect(result[0].model, 'F40');
    });

    test('should respect the cars per question limit', () async {
      // Arrange
      final mockCars = List.generate(30, (index) => {
        'id': index.toString(),
        'brand': 'Brand$index',
        'model': 'Model$index',
        'image_url': 'https://example.com/car$index.jpg',
        'answer': 'Brand$index Model$index'
      });

      await mockSupabase.from('quiz_cars').insert(mockCars);

      // Act
      final result = await carRepository.getRandomCars();

      // Assert
      expect(result.length, 25); // _kCarsPerQuestion = 25
    });
  });
} 