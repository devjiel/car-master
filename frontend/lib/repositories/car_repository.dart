import 'package:car_master/models/car_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const int _kCarsPerQuestion = 25;

class CarRepository {
  final SupabaseClient _supabase;

  CarRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<List<CarEntityModel>> getRandomCars() async {
    try {
      final response = await _supabase
          .from('quiz_cars')
          .select()
          .limit(_kCarsPerQuestion);
      
      final result = <CarEntityModel>[];
      
      for (final carData in response as List) {
        try {
          result.add(CarEntityModel.fromJson(carData));
        } catch (e) {
          // Skip malformed data
          print('Error with car data: $e');
        }
      }
      
      return result;
    } catch (e) {
      print('Error fetching cars: $e');
      return [];
    }
  }
} 