import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'filtered_accommodations.dart';
import '../../theme.dart';

class HousingPageContent extends StatefulWidget {
  const HousingPageContent({super.key});

  @override
  State<HousingPageContent> createState() => _HousingPageContentState();
}

class _HousingPageContentState extends State<HousingPageContent> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> propertyImages = [
      'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/1396122/pexels-photo-1396122.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
    ];

    const String predictionStatus = "wait";
    const String predictionMessage = predictionStatus == "good"
        ? "It's a great time to rent a property!"
        : predictionStatus == "bad"
            ? "Not a good time to rent. Prices are high."
            : "Wait for approximately 3 months for better prices.";

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: emeraldGreen,
        title: const Text('Housing App', style: TextStyle(color: whiteColor)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              FadeInDown(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: lightGrey.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: mediumGrey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by city, property type...',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: mediumGrey,
                          ),
                      prefixIcon: const Icon(Icons.search, color: darkGreen),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Price Prediction Widget
              SlideInLeft(
                duration: const Duration(milliseconds: 400),
                child: const PricePredictionWidget(
                  status: predictionStatus,
                  message: predictionMessage,
                ),
              ),
              const SizedBox(height: 24),

              // Properties Preview
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  'Top Properties',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: darkSlateGray,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final imageUrl = propertyImages[index % propertyImages.length];
                    return FadeInUp(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      child: PropertyCard(
                        imageUrl: imageUrl,
                        title: 'Property ${index + 1}',
                        price: '\$${1000 + (index * 200)}/month',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Market Statistics
              BounceInDown(
                duration: const Duration(milliseconds: 600),
                child: Text(
                  'Market Statistics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: darkSlateGray,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              BounceInDown(
                duration: const Duration(milliseconds: 700),
                child: const MarketStats(
                  averagePrice: '\$2,500',
                  priceGrowth: '3.5%',
                  availablePlaces: '500+',
                ),
              ),
              const SizedBox(height: 24),

              // View Filtered Accommodations Button
              ElasticIn(
                duration: const Duration(milliseconds: 400),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilteredAccommodationsPage(
                          // Do not pass accommodations, so CSV is loaded
                          searchQuery: _searchQuery,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emeraldGreen,
                    foregroundColor: whiteColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'View Filtered Accommodations',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: whiteColor,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class PricePredictionWidget extends StatelessWidget {
  final String status; // "good", "bad", or "wait"
  final String message;

  const PricePredictionWidget({
    super.key,
    required this.status,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData icon;
    switch (status) {
      case "good":
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case "bad":
        backgroundColor = Colors.red;
        icon = Icons.cancel;
        break;
      case "wait":
        backgroundColor = Colors.yellow;
        icon = Icons.hourglass_empty;
        break;
      default:
        backgroundColor = mediumGrey;
        icon = Icons.help_outline;
    }

    return Container(
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: mediumGrey.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: mintGreen.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    backgroundColor.withOpacity(0.2),
                    whiteColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ZoomIn(
                    duration: const Duration(milliseconds: 400),
                    child: Icon(icon, size: 40, color: backgroundColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price Prediction Analysis",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: darkSlateGray,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: darkSlateGray,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: warmGold.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const PropertyCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: mediumGrey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: mintGreen.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        imageUrl,
                        height: 120,
                        width: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 120,
                          width: 160,
                          color: lightGrey,
                          child: const Icon(Icons.error, color: mediumGrey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: darkSlateGray,
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            price,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: emeraldGreen,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: warmGold.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MarketStats extends StatelessWidget {
  final String averagePrice;
  final String priceGrowth;
  final String availablePlaces;

  const MarketStats({
    super.key,
    required this.averagePrice,
    required this.priceGrowth,
    required this.availablePlaces,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: mediumGrey.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: mintGreen.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    mintGreen.withOpacity(0.1),
                    whiteColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(context, 'Avg Price', averagePrice, Icons.monetization_on),
                  _buildStatItem(context, 'Growth', priceGrowth, Icons.trending_up),
                  _buildStatItem(context, 'Places', availablePlaces, Icons.place),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: warmGold.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        ZoomIn(
          duration: const Duration(milliseconds: 400),
          child: Icon(icon, color: darkGreen, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: darkSlateGray,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: emeraldGreen,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}