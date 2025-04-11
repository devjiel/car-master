import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../router/app_router.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final game = ref.read(gameProvider.notifier);

    if (gameState.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Car Master'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              game.resetGame();
              context.goNamed(RouteNames.home);
            },
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading data...'),
            ],
          ),
        ),
      );
    }


    if (gameState.cars.isEmpty || gameState.currentCar == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Car Master'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              game.resetGame();
              context.goNamed(RouteNames.home);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('No data available'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => game.resetGame(),
                child: const Text('Try again'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  game.resetGame();
                  context.goNamed(RouteNames.home);
                },
                child: const Text('Back to menu'),
              ),
            ],
          ),
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${gameState.currentQuestionIndex + 1}/${gameState.totalQuestions}'),
        leading: gameState.isAnswered ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitConfirmationDialog(context, gameState, game),
        ) : null,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Score: ${gameState.score}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Card(
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9, // Standard landscape ratio
                child: Image.asset(
                  gameState.currentCar!.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...gameState.currentOptions.map((option) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: gameState.isAnswered && option == gameState.selectedAnswer
                                    ? (gameState.isCorrect)
                                        ? Colors.green
                                        : Colors.red.shade300
                                    : null,
                              ),
                              onPressed: () => game.answerQuestion(option),
                              child: Text(option),
                            ),
                          );
                        }),
                        if (gameState.isAnswered)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (gameState.hasFinished) ...[
                                  ElevatedButton(
                                    onPressed: () => game.resetGame(),
                                    child: const Text('Restart'),
                                  ),
                                  const SizedBox(width: 16),
                                  OutlinedButton(
                                    onPressed: () {
                                      game.resetGame();
                                      context.goNamed(RouteNames.home);
                                    },
                                    child: const Text('Back to menu'),
                                  ),
                                ] else
                                  ElevatedButton(
                                    onPressed: () => game.nextQuestion(),
                                    child: const Text('Next question'),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Affiche une boîte de dialogue de confirmation avant de quitter le jeu
  Future<void> _showExitConfirmationDialog(BuildContext context, GameState gameState, GameNotifier game) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Game?'),
          content: const Text('Are you sure you want to exit the game? Your progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () => context.goNamed(RouteNames.home),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                game.resetGame();
                context.goNamed(RouteNames.home);
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      if (context.mounted) {
        context.goNamed(RouteNames.home);
      }
    }
  }
} 