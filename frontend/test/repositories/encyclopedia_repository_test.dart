import 'package:car_master/models/car_encyclopedia_entity.dart';
import 'package:car_master/repositories/encyclopedia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late SupabaseClient mockSupabase;
  late MockSupabaseHttpClient mockHttpClient;
  late EncyclopediaRepository encyclopediaRepository;

  setUp(() {
    mockHttpClient = MockSupabaseHttpClient();
    mockSupabase = SupabaseClient(
      'https://mock.supabase.co',
      'fakeAnonKey',
      httpClient: mockHttpClient,
    );
    encyclopediaRepository = EncyclopediaRepository(supabase: mockSupabase);
  });

  tearDown(() {
    mockHttpClient.reset();
  });

  group('getCarEncyclopediaSummaries', () {
    test('should return paginated list of encyclopedia summaries', () async {
      // Arrange
      final mockEntries = List.generate(25, (i) => {
        'id': 'car_$i',
        'name': 'Car $i',
        'short_description': 'Description $i',
        'description': 'Detailed description for car $i',
        'manufacturer_id': 'manufacturer_$i',
        'year': '202$i',
        'country_id': 'country_$i',
        'body_style_id': 'style_$i',
        'engine': 'Engine $i',
        'power': '200 hp',
        'torque': '300 Nm',
        'drivetrain': 'RWD',
        'acceleration': '5.$i s',
        'top_speed': '250 km/h',
        'dimensions': '4500x1800x1400 mm',
        'weight': '1500 kg',
        'history': 'History of car $i',
        'default_image_url': 'https://example.com/car_$i.jpg',
        'additional_specs': {'key': 'value'},
        'notable_facts': [],
        'awards': []
      });

      await mockSupabase.from('car_encyclopedia_entries').insert(mockEntries);

      // Act - First page
      final firstPage = await encyclopediaRepository.getCarEncyclopediaSummaries(page: 0);

      // Assert - First page
      expect(firstPage.length, 20); // pageSize
      expect(firstPage[0].name, 'Car 0');
      expect(firstPage[0].defaultImageUrl?.contains('example.com'), true);

      // Act - Second page
      final secondPage = await encyclopediaRepository.getCarEncyclopediaSummaries(page: 1);

      // Assert - Second page
      expect(secondPage.length, 5); // remaining items
    });

    test('should handle empty response', () async {
      // Act
      final result = await encyclopediaRepository.getCarEncyclopediaSummaries();

      // Assert
      expect(result, isEmpty);
    });

    test('should handle database error', () async {
      // Arrange
      mockHttpClient = MockSupabaseHttpClient(
        postgrestExceptionTrigger: (schema, table, data, type) {
          throw PostgrestException(
            message: 'Database error',
            code: '500',
          );
        },
      );
      mockSupabase = SupabaseClient(
        'https://mock.supabase.co',
        'fakeAnonKey',
        httpClient: mockHttpClient,
      );
      encyclopediaRepository = EncyclopediaRepository(supabase: mockSupabase);

      // Act & Assert
      expect(
        () => encyclopediaRepository.getCarEncyclopediaSummaries(),
        throwsA(isA<PostgrestException>()),
      );
    });
  });

  group('getCarEncyclopediaDetail', () {
    test('should return full car details when found', () async {
      // Arrange
      final mockEntry = {
        'id': '1',
        'name': 'Ferrari F40',
        'short_description': 'Iconic supercar from the 80s',
        'description': 'Detailed description of F40',
        'manufacturer_id': 'ferrari_id',
        'year': '1987',
        'country_id': 'italy_id',
        'designer_names': ['Leonardo Fioravanti', 'Pietro Camardella'],
        'body_style_id': 'supercar_id',
        'engine': 'Twin-turbo 2.9L V8',
        'power': '471 hp',
        'torque': '426 lb-ft',
        'drivetrain': 'RWD',
        'acceleration': '3.8s 0-60 mph',
        'top_speed': '201 mph',
        'dimensions': '4358x1970x1123 mm',
        'weight': '1100 kg',
        'additional_specs': {
          'transmission': '5-speed manual',
          'production': '1311 units'
        },
        'history': 'Created to celebrate Ferrari\'s 40th anniversary',
        'notable_facts': ['Last Ferrari approved by Enzo Ferrari'],
        'awards': ['Car of the Year 1987'],
        'default_image_url': 'https://example.com/f40.jpg'
      };

      await mockSupabase.from('car_encyclopedia_entries').insert([mockEntry]);

      // Act
      final result = await encyclopediaRepository.getCarEncyclopediaDetail('1');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, '1');
      expect(result.name, 'Ferrari F40');
      expect(result.shortDescription, 'Iconic supercar from the 80s');
      expect(result.defaultImageUrl, 'https://example.com/f40.jpg');
      expect(result.designerNames, ['Leonardo Fioravanti', 'Pietro Camardella']);
      expect(result.additionalSpecs['transmission'], '5-speed manual');
    });

    test('should return null when car not found', () async {
      // Act
      final result = await encyclopediaRepository.getCarEncyclopediaDetail('non_existent_id');

      // Assert
      expect(result, isNull);
    });

    test('should handle database error', () async {
      // Arrange
      mockHttpClient = MockSupabaseHttpClient(
        postgrestExceptionTrigger: (schema, table, data, type) {
          throw PostgrestException(
            message: 'Database error',
            code: '500',
          );
        },
      );
      mockSupabase = SupabaseClient(
        'https://mock.supabase.co',
        'fakeAnonKey',
        httpClient: mockHttpClient,
      );
      encyclopediaRepository = EncyclopediaRepository(supabase: mockSupabase);

      // Act & Assert
      expect(
        () => encyclopediaRepository.getCarEncyclopediaDetail('1'),
        throwsA(isA<PostgrestException>()),
      );
    });
  });
} 