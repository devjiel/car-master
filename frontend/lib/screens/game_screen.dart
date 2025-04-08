import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';

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
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Chargement des données...'),
            ],
          ),
        ),
      );
    }


    if (gameState.cars.isEmpty || gameState.currentCar == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Car Master'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Aucune donnée disponible'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => game.resetGame(),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${gameState.currentQuestionIndex + 1}/${gameState.totalQuestions}'),
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
                aspectRatio: 16 / 9, // Ratio paysage standard
                child: Image.asset(
                  gameState.currentCar!.imagePath,
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
                                        : Colors.red.withValues(alpha: 0.3)
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
                            child: ElevatedButton(
                              onPressed: gameState.hasFinished
                                  ? () => game.resetGame()
                                  : () => game.nextQuestion(),
                              child: Text(
                                gameState.hasFinished ? 'Recommencer' : 'Question suivante'
                              ),
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
} 