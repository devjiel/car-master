import 'package:car_master/screens/encyclopedia_detail_screen.dart';
import 'package:car_master/screens/encyclopedia_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/main_screen.dart';
import '../screens/game_screen.dart';

// Les noms des routes pour la navigation 
final class RouteNames {
  static const String home = 'home';
  static const String game = 'game';
  static const String encyclopedia = 'encyclopedia';
  static const String encyclopediaDetail = 'encyclopedia/:id';
}

// Les chemins des routes
final class RoutePaths {
  static const String home = '/';
  static const String game = '/game';
  static const String encyclopedia = '/encyclopedia';
  static const String encyclopediaDetail = '/encyclopedia/:id';
}

// Provider pour accéder au routeur depuis n'importe où dans l'application
final routerProvider = Provider<GoRouter>((ref) {
  return createRouter();
});

// Création du routeur avec la configuration des routes
GoRouter createRouter() {
  return GoRouter(
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: RoutePaths.game,
        name: RouteNames.game,
        builder: (context, state) => const GameScreen(),
      ),
      GoRoute(
        path: RoutePaths.encyclopedia,
        name: RouteNames.encyclopedia,
        builder: (context, state) => const EncyclopediaScreen(),
      ),
      GoRoute(
        path: RoutePaths.encyclopediaDetail,
        name: RouteNames.encyclopediaDetail,
        builder: (context, state) => EncyclopediaDetailScreen(id: state.pathParameters['id']),
      ),
    ],
  );
} 