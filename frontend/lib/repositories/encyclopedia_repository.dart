import 'package:car_master/models/car_encyclopedia_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EncyclopediaRepository {
  final SupabaseClient _supabase;

  EncyclopediaRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<List<CarEncyclopediaEntity>> getCarEncyclopedia() async {
    try {
      final response = await _supabase.from('car_encyclopedia_entries').select('*'); // TODO: add pagination
      final result = <CarEncyclopediaEntity>[];
      
      for (final json in response as List) {
        try {
          result.add(CarEncyclopediaEntity.fromJson(json));
        } catch (e) {
          print('Error parsing encyclopedia entry: $e');
          // Skip invalid entries
        }
      }
      
      return result;
    } catch (e) {
      if (e is PostgrestException) {
        rethrow;
      }
      print('Error fetching encyclopedia: $e');
      return [];
    }
  }
}
