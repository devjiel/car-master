import 'package:car_master/models/entities/quiz_car_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const int _kCarsPerQuestion = 25;

class QuizCarRepository {
  final SupabaseClient _supabase;

  QuizCarRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<List<QuizCarEntityModel>> getRandomCars() async {
    try {
      final response = await _supabase
          .from('quiz_cars')
          .select()
          .limit(_kCarsPerQuestion);
      
      final result = <QuizCarEntityModel>[];
      
      for (final carData in response as List) {
        try {
          result.add(QuizCarEntityModel.fromJson(carData));
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