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

  group('getCarEncyclopedia', () {
    test('should return list of encyclopedia entries when data is valid', () async {
      // Arrange
      final mockEntries = [
        {
          'id': '1',
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
          'awards': ['Car of the Year 1987']
        },
        {
          'id': '2',
          'short_description': 'Legendary sports car',
          'description': 'Detailed description of 911',
          'manufacturer_id': 'porsche_id',
          'year': '1963',
          'country_id': 'germany_id',
          'designer_names': ['Ferdinand Alexander Porsche'],
          'body_style_id': 'coupe_id',
          'engine': 'Flat-six',
          'power': '130 hp',
          'torque': '128 lb-ft',
          'drivetrain': 'RWD',
          'acceleration': '8.3s 0-60 mph',
          'top_speed': '130 mph',
          'dimensions': '4290x1610x1320 mm',
          'weight': '1080 kg',
          'additional_specs': {
            'transmission': '5-speed manual',
            'production': 'Continuous'
          },
          'history': 'Evolution of the Porsche 356',
          'notable_facts': ['Most successful sports car ever'],
          'awards': ['Car of the Century nominee']
        }
      ];

      await mockSupabase.from('car_encyclopedia_entries').insert(mockEntries);

      // Act
      final result = await encyclopediaRepository.getCarEncyclopedia();

      // Assert
      expect(result.length, 2);
      expect(result[0], isA<CarEncyclopediaEntity>());
      expect(result[0].id, '1');
      expect(result[0].shortDescription, 'Iconic supercar from the 80s');
      expect(result[0].manufacturerId, 'ferrari_id');
      expect(result[0].designerNames, ['Leonardo Fioravanti', 'Pietro Camardella']);
      expect(result[0].additionalSpecs['transmission'], '5-speed manual');
      expect(result[0].notableFacts, ['Last Ferrari approved by Enzo Ferrari']);

      expect(result[1].id, '2');
      expect(result[1], isA<CarEncyclopediaEntity>());
      expect(result[1].shortDescription, 'Legendary sports car');
      expect(result[1].manufacturerId, 'porsche_id');
      expect(result[1].designerNames, ['Ferdinand Alexander Porsche']);
      expect(result[1].additionalSpecs['production'], 'Continuous');
      expect(result[1].notableFacts, ['Most successful sports car ever']);
    });

    test('should handle empty response', () async {
      // Act
      final result = await encyclopediaRepository.getCarEncyclopedia();

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
        () => encyclopediaRepository.getCarEncyclopedia(),
        throwsA(isA<PostgrestException>()),
      );
    });

    test('should handle malformed data', () async {
      // Arrange
      final mockEntries = [
        {
          'id': '1',
          'short_description': 'Valid entry',
          'description': 'Valid description',
          'manufacturer_id': 'ferrari_id',
          'year': '1987',
          'country_id': 'italy_id',
          'body_style_id': 'supercar_id',
          'engine': 'V8',
          'power': '471 hp',
          'torque': '426 lb-ft',
          'drivetrain': 'RWD',
          'acceleration': '3.8s',
          'top_speed': '201 mph',
          'dimensions': '4358x1970x1123 mm',
          'weight': '1100 kg',
          'additional_specs': {'key': 'value'},
          'history': 'Valid history',
          'notable_facts': [],
          'awards': []
        },
        {
          'id': '2',
          'short_description': null,
          'description': null,
          'manufacturer_id': 'porsche_id',
          'year': null,
          'country_id': null,
          'body_style_id': null,
          'engine': null,
          'power': null,
          'torque': null,
          'drivetrain': null,
          'acceleration': null,
          'top_speed': null,
          'dimensions': null,
          'weight': null,
          'additional_specs': null,
          'history': null
        }
      ];

      await mockSupabase.from('car_encyclopedia_entries').insert(mockEntries);

      // Act
      final result = await encyclopediaRepository.getCarEncyclopedia();

      // Assert
      expect(result.length, 1);
      expect(result[0].id, '1');
      expect(result[0].shortDescription, 'Valid entry');
    });
  });
} 