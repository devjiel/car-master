import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_master/providers/encyclopedia_provider.dart';
import 'package:car_master/models/car_encyclopedia_detail.dart';

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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Car Details'),
        ),
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
      ),
    );
  }

  Widget _buildCarDetail(BuildContext context, CarEncyclopediaDetail carDetail) {
    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  carDetail.car.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Image.network(
                  carDetail.car.defaultImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // TODO: add manufacturer logo
                        // if (carDetail.manufacturer.logoUrl != null)
                        //   Padding(
                        //     padding: const EdgeInsets.only(right: 8.0),
                        //     child: ClipRRect(
                        //       borderRadius: BorderRadius.circular(8.0),
                        //       child: Image.network(
                        //         carDetail.manufacturer.logoUrl!,
                        //         height: 40,
                        //         width: 40,
                        //         fit: BoxFit.contain,
                        //       ),
                        //     ),
                        //   ),
                        Text(
                          carDetail.manufacturer.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        // TODO: add country flag
                        // if (carDetail.country.flagUrl != null)
                        //   Image.network(
                        //     carDetail.country.flagUrl!,
                        //     height: 24,
                        //     width: 36,
                        //     fit: BoxFit.cover,
                        //   ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      carDetail.car.shortDescription,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                const TabBar(
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Specs'),
                    Tab(text: 'History'),
                    Tab(text: 'Images'),
                  ],
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          children: [
            _buildOverviewTab(context, carDetail),
            _buildSpecificationsTab(context, carDetail),
            _buildHistoryTab(context, carDetail),
            // TODO: add images tab
            Placeholder(),
            //  _buildImagesTab(context, carDetail),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, CarEncyclopediaDetail carDetail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(carDetail.car.description),
          const SizedBox(height: 16),
          const Text(
            'Key Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoItem('Manufacturer', carDetail.manufacturer.name),
          _buildInfoItem('Year', carDetail.car.year),
          _buildInfoItem('Country', carDetail.country.name),
          _buildInfoItem('Body Style', carDetail.bodyStyle.name),
          if (carDetail.car.designerNames != null && carDetail.car.designerNames!.isNotEmpty)
            _buildInfoItem('Designer(s)', carDetail.car.designerNames!.join(', ')),
        ],
      ),
    );
  }

  Widget _buildSpecificationsTab(BuildContext context, CarEncyclopediaDetail carDetail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Engine & Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoItem('Engine', carDetail.car.engine),
          _buildInfoItem('Power', carDetail.car.power),
          _buildInfoItem('Torque', carDetail.car.torque),
          _buildInfoItem('Drivetrain', carDetail.car.drivetrain),
          _buildInfoItem('Acceleration', carDetail.car.acceleration),
          _buildInfoItem('Top Speed', carDetail.car.topSpeed),
          const SizedBox(height: 16),
          const Text(
            'Dimensions & Weight',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoItem('Dimensions', carDetail.car.dimensions),
          _buildInfoItem('Weight', carDetail.car.weight),
          if (carDetail.car.additionalSpecs.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Additional Specifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...carDetail.car.additionalSpecs.entries.map(
              (entry) => _buildInfoItem(entry.key, entry.value),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHistoryTab(BuildContext context, CarEncyclopediaDetail carDetail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(carDetail.car.history),
          if (carDetail.car.notableFacts.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Notable Facts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...carDetail.car.notableFacts.map((fact) => _buildFactItem(fact)),
          ],
          if (carDetail.car.awards.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Awards',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...carDetail.car.awards.map((award) => _buildFactItem(award)),
          ],
        ],
      ),
    );
  }

  Widget _buildImagesTab(BuildContext context, CarEncyclopediaDetail carDetail) {
    if (carDetail.images == null || carDetail.images!.isEmpty) {
      return const Center(
        child: Text('No additional images available'),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: carDetail.images!.length,
      itemBuilder: (context, index) {
        final image = carDetail.images![index];
        return GestureDetector(
          onTap: () {
            // TODO: Open image in full screen
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              image.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.image_not_supported, size: 50),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildFactItem(String fact) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0, top: 4.0),
            child: Icon(Icons.circle, size: 8),
          ),
          Expanded(
            child: Text(fact),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}