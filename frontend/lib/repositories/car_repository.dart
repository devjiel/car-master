import '../models/car.dart';
import '../services/supabase_service.dart';

class CarRepository {
  final _supabase = SupabaseService.client;

  Future<List<Car>> getAllCars() async {
    try {
      final response = await _supabase
          .from('cars')
          .select()
          .order('id');
      
      return response.map((carData) => Car(
        id: carData['id'].toString(),
        brand: carData['brand'],
        model: carData['model'],
        imagePath: carData['image_path'],
        answer: carData['answer'],
      )).toList();
    } catch (e) {
      print('Error fetching cars: $e');
      return [];
    }
  }
  
  Future<Car?> getCarById(String id) async {
    try {
      final response = await _supabase
          .from('cars')
          .select()
          .eq('id', id)
          .single();
      
      return Car(
        id: response['id'].toString(),
        brand: response['brand'],
        model: response['model'],
        imagePath: response['image_path'],
        answer: response['answer'],
      );
    } catch (e) {
      print('Error fetching car: $e');
      return null;
    }
  }
} 