import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:car_master/providers/encyclopedia_provider.dart';
import 'package:car_master/models/entities/car_encyclopedia_entity.dart';

class EncyclopediaScreen extends ConsumerStatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  ConsumerState<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends ConsumerState<EncyclopediaScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial data after the build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(carEncyclopediaListProvider.notifier).loadInitialCars();
    });

    // Add a listener to detect when we reach the bottom of the list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
        ref.read(carEncyclopediaListProvider.notifier).loadMoreCars();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(carEncyclopediaListProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Car Encyclopedia'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Implement search
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => ref.read(carEncyclopediaListProvider.notifier).refreshCars(),
          child: state.error != null && state.cars.isEmpty
              ? _buildErrorWidget(state.error!)
              : state.cars.isEmpty && state.isLoading
                  ? _buildLoadingWidget()
                  : _buildCarList(state.cars, state.isLoading, state.hasMorePages),
        ),
      ),
    );
  }

  Widget _buildCarList(List<CarEncyclopediaEntity> cars, bool isLoading, bool hasMorePages) {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemCount: cars.length + (isLoading && hasMorePages ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == cars.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final car = cars[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.go('/encyclopedia/${car.id}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network( // TODO: use cached image
                    car.defaultImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          car.shortDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading data',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(carEncyclopediaListProvider.notifier).refreshCars();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}