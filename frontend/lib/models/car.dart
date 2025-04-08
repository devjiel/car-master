class Car {
  final String id;
  final String brand;
  final String model;
  final String imagePath;
  final String answer;

  const Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.imagePath,
    required this.answer,
  });

  @override
  String toString() => '$brand $model';
} 