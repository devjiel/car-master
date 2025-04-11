import 'package:car_master/models/car_encyclopedia_detail.dart';
import 'package:car_master/models/entities/car_encyclopedia_entity.dart';
import 'package:car_master/repositories/encyclopedia_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider pour accéder au repository de l'encyclopédie
final encyclopediaRepositoryProvider = Provider<EncyclopediaRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return EncyclopediaRepository(supabase: supabase);
});

// État de la liste paginée des voitures
class CarEncyclopediaState {
  final List<CarEncyclopediaEntity> cars;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMorePages;

  CarEncyclopediaState({
    required this.cars,
    required this.isLoading,
    this.error,
    required this.currentPage,
    required this.hasMorePages,
  });

  CarEncyclopediaState.initial()
      : cars = [],
        isLoading = false,
        error = null,
        currentPage = 0,
        hasMorePages = true;

  CarEncyclopediaState copyWith({
    List<CarEncyclopediaEntity>? cars,
    bool? isLoading,
    String? error,
    bool clearError = false,
    int? currentPage,
    bool? hasMorePages,
  }) {
    return CarEncyclopediaState(
      cars: cars ?? this.cars,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }
}

// NotifierProvider pour gérer la liste des voitures avec pagination
class CarEncyclopediaListNotifier extends StateNotifier<CarEncyclopediaState> {
  final EncyclopediaRepository _repository;

  CarEncyclopediaListNotifier(this._repository) : super(CarEncyclopediaState.initial());

  // Charger la première page
  Future<void> loadInitialCars() async {
    if (state.cars.isNotEmpty) return;
    await _loadCars(0, refresh: true);
  }

  // Rafraîchir la liste complète
  Future<void> refreshCars() async {
    await _loadCars(0, refresh: true);
  }

  // Charger la page suivante
  Future<void> loadMoreCars() async {
    if (state.isLoading || !state.hasMorePages) return;
    await _loadCars(state.currentPage + 1);
  }

  // Méthode interne pour charger les données
  Future<void> _loadCars(int page, {bool refresh = false}) async {
    try {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        cars: refresh ? [] : null,
        currentPage: refresh ? 0 : null,
      );

      final cars = await _repository.getCarEncyclopediaList(page: page);
      
      final hasMore = cars.length >= EncyclopediaRepository.pageSize;
      
      state = state.copyWith(
        cars: refresh ? cars : [...state.cars, ...cars],
        isLoading: false,
        currentPage: page,
        hasMorePages: hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

// Provider pour la liste des voitures
final carEncyclopediaListProvider = StateNotifierProvider<CarEncyclopediaListNotifier, CarEncyclopediaState>((ref) {
  final repository = ref.watch(encyclopediaRepositoryProvider);
  return CarEncyclopediaListNotifier(repository);
});

// Provider pour le détail d'une voiture
final carEncyclopediaDetailProvider = FutureProvider.family<CarEncyclopediaDetail?, String>((ref, carId) async {
  final repository = ref.watch(encyclopediaRepositoryProvider);
  return await repository.getCarEncyclopediaDetailWithRelations(carId);
});

// Provider pour Supabase nécessaire aux repositories
final supabaseClientProvider = Provider((ref) {
  return Supabase.instance.client;
});
