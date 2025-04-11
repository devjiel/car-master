import 'package:car_master/models/car_encyclopedia_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EncyclopediaRepository {
  final SupabaseClient _supabase;
  static const int pageSize = 20;

  EncyclopediaRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<List<CarEncyclopediaEntity>> getCarEncyclopediaSummaries({int page = 0}) async {
    try {
      final response = await _supabase
          .from('car_encyclopedia_entries')
          .select('*')
          .range(page * pageSize, (page + 1) * pageSize - 1)
          .order('name', ascending: true);

      final result = <CarEncyclopediaEntity>[];
      
      for (final json in response as List) {
        try {
          result.add(CarEncyclopediaEntity.fromJson(json));
        } catch (e) {
          print('Error parsing encyclopedia entry summary: $e');
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

  Future<CarEncyclopediaEntity?> getCarEncyclopediaDetail(String id) async {
    try {
      final response = await _supabase
          .from('car_encyclopedia_entries')
          .select('*')
          .eq('id', id)
          .limit(1)
          .maybeSingle();
      
      if (response == null) {
        return null;
      }
      
      return CarEncyclopediaEntity.fromJson(response);
    } catch (e) {
      if (e is PostgrestException) {
        rethrow;
      }
      print('Error fetching encyclopedia detail: $e');
      return null;
    }
  }
}
