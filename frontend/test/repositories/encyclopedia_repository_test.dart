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
      final firstPage = await encyclopediaRepository.getCarEncyclopediaList(page: 0);

      // Assert - First page
      expect(firstPage.length, 20); // pageSize
      expect(firstPage[0].id.startsWith('car_'), true);
      expect(firstPage[0].name.startsWith('Car '), true);
      expect(firstPage[0].defaultImageUrl.contains('example.com'), true);

      // Act - Second page
      final secondPage = await encyclopediaRepository.getCarEncyclopediaList(page: 1);

      // Assert - Second page
      expect(secondPage.length, 5); // remaining items
    });

    test('should handle empty response', () async {
      // Act
      final result = await encyclopediaRepository.getCarEncyclopediaList();

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
        () => encyclopediaRepository.getCarEncyclopediaList(),
        throwsA(isA<PostgrestException>()),
      );
    });
  });
  
  group('getCarEncyclopediaDetailWithRelations', () {
    test('should return detailed car with related entities', () async {
      // Arrange
      final carId = '123e4567-e89b-12d3-a456-426614174000';
      final manufacturerId = '33b2d0c3-172b-4867-8d9a-cfda5a9e90c5';
      final countryId = '2349bdef-4863-4752-86f0-4e46ea2fde48';
      final bodyStyleId = '66ed89d8-02ae-4811-82cf-5fcfc01b817e';
      
      // Selon la documentation mock_supabase_http_client, nous devons insérer
      // les données avec la structure que nous attendons lors de la jointure
      final mockCarWithRelations = {
        'id': carId,
        'name': 'Porsche 911 GT3',
        'short_description': 'High-performance sports car',
        'description': 'The Porsche 911 GT3 is a high-performance sports car',
        'manufacturer_id': manufacturerId,
        'year': '2021',
        'country_id': countryId,
        'designer_names': ['Andreas Preuninger'],
        'body_style_id': bodyStyleId,
        'engine': 'Flat-six',
        'power': '502 hp',
        'torque': '346 lb-ft',
        'drivetrain': 'RWD',
        'acceleration': '3.2s',
        'top_speed': '197 mph',
        'dimensions': '178 x 73 x 51 inches',
        'weight': '3116 lbs',
        'additional_specs': { 'transmission': '7-speed PDK' },
        'history': 'The 911 GT3 has been the most track-focused 911 since 1999',
        'notable_facts': ['Nürburgring lap time of 6:59.927'],
        'awards': ['Performance Car of the Year 2022'],
        'default_image_url': 'https://example.com/porsche_911_gt3.jpg',
        // Ajout des données liées directement dans l'objet
        'manufacturer': {
          'id': manufacturerId,
          'name': 'Porsche',
          'country': 'Germany',
          'description': 'German sports car manufacturer',
          'founding_year': 1931
        },
        'country': {
          'id': countryId,
          'name': 'Germany',
          'code': 'DE',
          'flag_url': 'flags/germany.png'
        },
        'body_style': {
          'id': bodyStyleId,
          'name': 'Coupe',
          'description': 'Two-door fixed roof car'
        }
      };
      
      // Insertion de la voiture avec toutes ses relations
      await mockSupabase.from('car_encyclopedia_entries').insert([mockCarWithRelations]);
      
      // Insertion des images pour la voiture
      await mockSupabase.from('car_encyclopedia_images').insert([
        {
          'id': 'img1',
          'encyclopedia_entry_id': carId,
          'image_url': 'https://example.com/image1.jpg',
          'caption': 'Front view',
          'display_order': 1
        },
        {
          'id': 'img2',
          'encyclopedia_entry_id': carId,
          'image_url': 'https://example.com/image2.jpg',
          'caption': 'Rear view',
          'display_order': 2
        }
      ]);
      
      // Act
      final result = await encyclopediaRepository.getCarEncyclopediaDetailWithRelations(carId);
      
      // Assert
      expect(result, isNotNull);
      expect(result!.car.id, carId);
      expect(result.car.name, 'Porsche 911 GT3');
      expect(result.manufacturer.name, 'Porsche');
      expect(result.country.name, 'Germany');
      expect(result.bodyStyle.name, 'Coupe');
      expect(result.images!.length, 2);
      
      // We check that the images are present but without guaranteeing their exact order
      expect(result.images!.any((img) => img.imageUrl == 'https://example.com/image1.jpg'), true);
      expect(result.images!.any((img) => img.imageUrl == 'https://example.com/image2.jpg'), true);
      expect(result.images!.any((img) => img.caption == 'Front view'), true);
      expect(result.images!.any((img) => img.caption == 'Rear view'), true);
    });
    
    test('should return null when car not found', () async {
      // Act
      final result = await encyclopediaRepository.getCarEncyclopediaDetailWithRelations('non_existent_id');
      
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
        () => encyclopediaRepository.getCarEncyclopediaDetailWithRelations('1'),
        throwsA(isA<PostgrestException>()),
      );
    });
  });
} 