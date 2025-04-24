import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_master/providers/encyclopedia_provider.dart';
import 'package:car_master/models/car_encyclopedia_detail.dart';
import 'package:go_router/go_router.dart';

class EncyclopediaDetailScreen extends ConsumerWidget {
  const EncyclopediaDetailScreen({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == null) {
      return const Center(
        child: Text('No ID provided'),
      );
    }
    final carId = id!;
    final carDetailAsync = ref.watch(carEncyclopediaDetailProvider(carId));

    return Scaffold(
      backgroundColor: Colors.black,
      body: carDetailAsync.when(
        data: (carDetail) {
          if (carDetail == null) {
            return const Center(
              child: Text('Car not found'),
            );
          }
          return _buildCarDetail(context, carDetail);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
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
                'Error loading car details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.refresh(carEncyclopediaDetailProvider(carId));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarDetail(BuildContext context, CarEncyclopediaDetail carDetail) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 400.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.black,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
              title: Builder(
                builder: (context) {
                  final FlexibleSpaceBarSettings? settings = 
                      context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
                  final bool isCollapsed = settings?.minExtent == settings?.currentExtent;
                  
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isCollapsed ? 1.0 : 0.0,
                    child: Text(
                      carDetail.car.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              ),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                titlePadding: EdgeInsets.zero,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.grey.shade900,
                              Colors.grey.shade300,
                            ],
                            stops: const [0.0, 0.85],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.15,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          '911 GT3',// TODO carDetail.car.name,
                          style: const TextStyle(
                            color: Colors.white24,
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/cars/porsche_911_gt3_header.png',
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SafeArea(
                          child: Center(
                            child: Image.asset(
                              'assets/logos/autocorner_logo.png',
                              height: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                carDetail.car.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                height: 24,
                                width: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.black,
                                ),
                                child: const Center(
                                  child: Text(
                                    'DE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildMainInfo(context, carDetail),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSpecificationsSection(context, carDetail),
                _buildGallerySection(context, carDetail),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainInfo(BuildContext context, CarEncyclopediaDetail carDetail) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildInfoCard('Top speed', '${carDetail.car.topSpeed.split(' ')[0]} km/h'),
              const SizedBox(width: 16),
              _buildInfoCard('Speed', carDetail.car.acceleration),
              const SizedBox(width: 16),
              _buildInfoCard('Weight', carDetail.car.weight),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            carDetail.car.shortDescription,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            carDetail.car.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsSection(BuildContext context, CarEncyclopediaDetail carDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Specifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildSpecItem('Engine', 'Twin Turbo V8'),
        _buildSpecItem('Engine', 'Twin Turbo V8'),
        _buildSpecItem('Engine', 'Twin Turbo V8'),
        _buildSpecItem('Engine', 'Twin Turbo V8'),
        _buildSpecItem('Engine', 'Twin Turbo V8'),
        _buildSpecItem('Engine', 'Twin Turbo V8'),
      ],
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(
            height: 0.5,
            thickness: 0.5,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(BuildContext context, CarEncyclopediaDetail carDetail) {
    final List<String> demoImages = [
      'https://images.unsplash.com/photo-1632154939368-1a92207d8af3?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8cG9yc2NoZSUyMDkxMXxlbnwwfHwwfHx8MA%3D%3D',
      'https://images.unsplash.com/photo-1632154939368-1a92207d8af3?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8cG9yc2NoZSUyMDkxMXxlbnwwfHwwfHx8MA%3D%3D',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gallery',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: demoImages
              .map(
                (imageUrl) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}