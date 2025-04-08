import 'package:car_master/models/car.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CarRepository {
  final SupabaseClient _supabase;

  // Constructor with optional parameter
  CarRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<List<Car>> getAllCars() async {
    try {
      final response = await _supabase
          .from('cars')
          .select()
          .order('id');
      
      final result = <Car>[];
      
      for (final carData in response as List) {
        try {
          result.add(Car(
            id: carData['id'].toString(),
            brand: carData['brand'],
            model: carData['model'],
            imagePath: carData['image_path'],
            answer: carData['answer'],
          ));
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