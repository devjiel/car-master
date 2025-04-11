import 'package:car_master/models/car_encyclopedia_detail.dart';
import 'package:car_master/models/entities/car_encyclopedia_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EncyclopediaRepository {
  final SupabaseClient _supabase;
  static const int pageSize = 20;

  EncyclopediaRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<List<CarEncyclopediaEntity>> getCarEncyclopediaList({int page = 0}) async {
    try {
      final response = await _supabase
          .from('car_encyclopedia_entries')
          .select('*') // TODO: add only relevant fields
          .range(page * pageSize, (page + 1) * pageSize - 1)
          .order('name', ascending: true);

      final result = <CarEncyclopediaEntity>[];
      
      for (final json in response as List) {
        try {
          result.add(CarEncyclopediaEntity.fromJson(json));
        } catch (e) {
          print('Error parsing encyclopedia entry list: $e');
        }
      }
      
      return result;
    } catch (e) {
      if (e is PostgrestException) {
        rethrow;
      }
      print('Error fetching encyclopedia summaries: $e');
      return [];
    }
  }
  
  /// Récupère les détails complets d'une voiture avec ses relations
  /// en utilisant une seule requête avec jointures
  Future<CarEncyclopediaDetail?> getCarEncyclopediaDetailWithRelations(String id) async {
    try {
      // Utilisation de jointures pour récupérer toutes les données en une seule requête
      final response = await _supabase
          .from('car_encyclopedia_entries')
          .select('''
            *,
            manufacturer:manufacturers(*),
            country:countries(*),
            body_style:body_styles(*)
          ''')
          .eq('id', id)
          .limit(1)
          .maybeSingle();
      
      if (response == null) {
        return null;
      }
      
      // Construction du modèle enrichi
      final car = CarEncyclopediaEntity.fromJson({
        ...response,
        'manufacturer_id': response['manufacturer']['id'],
        'country_id': response['country']['id'],
        'body_style_id': response['body_style']['id'],
      });
      
      final manufacturer = ManufacturerEntity.fromJson(response['manufacturer']);
      final country = CountryEntity.fromJson(response['country']);
      final bodyStyle = BodyStyleEntity.fromJson(response['body_style']);
      
      // Récupération des images dans une requête séparée
      final images = await getCarEncyclopediaImages(id);
      
      return CarEncyclopediaDetail(
        car: car,
        manufacturer: manufacturer,
        country: country,
        bodyStyle: bodyStyle,
        images: images,
      );
    } catch (e) {
      if (e is PostgrestException) {
        rethrow;
      }
      print('Error fetching encyclopedia detail with relations: $e');
      return null;
    }
  }
  
  /// Récupère les images d'une voiture de l'encyclopédie
  Future<List<CarEncyclopediaImage>> getCarEncyclopediaImages(String carId) async {
    try {
      final response = await _supabase
          .from('encyclopedia_images')
          .select('*')
          .eq('encyclopedia_entry_id', carId)
          .order('display_order');
      
      return (response as List)
          .map((json) => CarEncyclopediaImage.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching car images: $e');
      return [];
    }
  }
}
