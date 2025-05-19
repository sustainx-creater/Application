import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../theme.dart';
import 'utils/csv_reader.dart';

class FilteredAccommodationsPage extends StatefulWidget {
  final List<Map<String, dynamic>>? accommodations;
  final String? searchQuery;

  const FilteredAccommodationsPage({
    super.key,
    this.accommodations,
    this.searchQuery,
  });

  @override
  State<FilteredAccommodationsPage> createState() => _FilteredAccommodationsPageState();
}

class _FilteredAccommodationsPageState extends State<FilteredAccommodationsPage> {
  late Future<List<Map<String, dynamic>>> _futureAccommodations;
  int _currentPage = 0;
  final int _itemsPerPage = 15;

  // Filter state
  String? _bedroomsFilter;
  String? _propertyTypeFilter;
  String? _sizeFilter;
  String? _stateFilter;
  bool? _sharedFilter;
  String? _distanceFilter;

  @override
  void initState() {
    super.initState();
    _loadAccommodations();
  }

  void _loadAccommodations() {
    _futureAccommodations = (widget.accommodations != null
        ? Future.value(widget.accommodations)
        : loadAccommodationsFromCsv())
        .then((data) {

      return _applyFilters(data ?? []);
    }).catchError((e) {

      return <Map<String, dynamic>>[];
    });
  }

  List<Map<String, dynamic>> _applyFilters(List<Map<String, dynamic>> data) {
    var filteredData = data;
    final query = widget.searchQuery?.toLowerCase();

    if (query != null && query.isNotEmpty) {
      filteredData = filteredData.where((acc) {
        return (acc['propertyType']?.toString().toLowerCase().contains(query) ?? false) ||
            (acc['state']?.toString().toLowerCase().contains(query) ?? false) ||
            (acc['description']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (_bedroomsFilter != null) {
      filteredData = filteredData
          .where((acc) => acc['numBedrooms']?.toString() == _bedroomsFilter)
          .toList();
    }
    if (_propertyTypeFilter != null) {
      filteredData = filteredData
          .where((acc) => acc['propertyType']?.toString() == _propertyTypeFilter)
          .toList();
    }
    if (_sizeFilter != null) {
      filteredData = filteredData
          .where((acc) => acc['propertySize_m']?.toString() == _sizeFilter)
          .toList();
    }
    if (_stateFilter != null) {
      filteredData = filteredData
          .where((acc) => acc['state']?.toString() == _stateFilter)
          .toList();
    }
    if (_sharedFilter != null) {
      filteredData = filteredData
          .where((acc) => (acc['shared_or_not'] == '1') == _sharedFilter)
          .toList();
    }
    if (_distanceFilter != null) {
      filteredData = filteredData.where((acc) {
        final distance = double.tryParse(acc['sph_dist']?.toString() ?? '0') ?? 0;
        switch (_distanceFilter) {
          case '1-3 km':
            return distance >= 1 && distance <= 3;
          case '4-6 km':
            return distance >= 4 && distance <= 6;
          case '7-10 km':
            return distance >= 7 && distance <= 10;
          case '>10 km':
            return distance > 10;
          default:
            return true;
        }
      }).toList();
    }

    return filteredData;
  }

  String _getFirstParagraph(String? description) {
    if (description == null || description.isEmpty) return 'No description available';
    final paragraphs = description.split('\n\n');
    return paragraphs.isNotEmpty ? paragraphs.first : description;
  }

  void _showFilterDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Filters',
      pageBuilder: (context, animation, secondaryAnimation) {
        String? tempBedrooms = _bedroomsFilter;
        String? tempPropertyType = _propertyTypeFilter;
        String? tempSize = _sizeFilter;
        String? tempState = _stateFilter;
        bool? tempShared = _sharedFilter;
        String? tempDistance = _distanceFilter;

        return Center(
          child: SlideInUp(
            duration: const Duration(milliseconds: 300),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: whiteColor.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: mediumGrey.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Filter Accommodations',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: darkSlateGray,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Bedrooms',
                        labelStyle: const TextStyle(color: darkSlateGray),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: lightGrey,
                      ),
                      value: tempBedrooms,
                      items: ['1.0', '2.0', '3.0', '4.0']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) => tempBedrooms = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Property Type',
                        labelStyle: const TextStyle(color: darkSlateGray),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: lightGrey,
                      ),
                      value: tempPropertyType,
                      items: ['House', 'Sharing', 'Apartment']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) => tempPropertyType = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Size (m²)',
                        labelStyle: const TextStyle(color: darkSlateGray),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: lightGrey,
                      ),
                      value: tempSize,
                      items: ['10.0', '20.0', '30.0', '48.0']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) => tempSize = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'State',
                        labelStyle: const TextStyle(color: darkSlateGray),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: lightGrey,
                      ),
                      value: tempState,
                      items: ['DELETED','PUBLISHED'] // Replace with actual states
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) => tempState = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<bool>(
                      decoration: InputDecoration(
                        labelText: 'Shared',
                        labelStyle: const TextStyle(color: darkSlateGray),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: lightGrey,
                      ),
                      value: tempShared,
                      items: const [
                        DropdownMenuItem(value: true, child: Text('Shared')),
                        DropdownMenuItem(value: false, child: Text('Not Shared')),
                      ],
                      onChanged: (value) => tempShared = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Distance',
                        labelStyle: const TextStyle(color: darkSlateGray),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: lightGrey,
                      ),
                      value: tempDistance,
                      items: ['1-3 km', '4-6 km', '7-10 km', '>10 km']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) => tempDistance = value,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: mediumGrey,
                                ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _bedroomsFilter = tempBedrooms;
                              _propertyTypeFilter = tempPropertyType;
                              _sizeFilter = tempSize;
                              _stateFilter = tempState;
                              _sharedFilter = tempShared;
                              _distanceFilter = tempDistance;
                              _currentPage = 0;
                              _loadAccommodations();
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: emeraldGreen,
                            foregroundColor: whiteColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Apply'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _bedroomsFilter = null;
                              _propertyTypeFilter = null;
                              _sizeFilter = null;
                              _stateFilter = null;
                              _sharedFilter = null;
                              _distanceFilter = null;
                              _currentPage = 0;
                              _loadAccommodations();
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Clear',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: warmGold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text('Explore Accommodations'),
        backgroundColor: emeraldGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: whiteColor),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureAccommodations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: emeraldGreen),
            );
          }
          if (snapshot.hasError) {
            print('FutureBuilder error: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading data',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(_loadAccommodations),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: emeraldGreen,
                      foregroundColor: whiteColor,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final accommodations = snapshot.data ?? [];
          if (accommodations.isEmpty) {
            return Center(
              child: Text(
                'No accommodations found.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          final startIndex = _currentPage * _itemsPerPage;
          final endIndex = (startIndex + _itemsPerPage) < accommodations.length
              ? (startIndex + _itemsPerPage)
              : accommodations.length;
          final pageAccommodations = accommodations.sublist(startIndex, endIndex);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: pageAccommodations.length,
                  itemBuilder: (context, index) {
                    final acc = pageAccommodations[index];
                    return FadeInUp(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      child: GestureDetector(
                        onTap: () {
                          // Add tap animation or navigation
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: whiteColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
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
                                borderRadius: BorderRadius.circular(20),
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
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  '${acc['propertyType'] ?? 'Unknown'} - ${acc['price'] ?? 'N/A'}',
                                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                        color: darkSlateGray,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                              ZoomIn(
                                                duration: const Duration(milliseconds: 400),
                                                child: const Icon(
                                                  Icons.home,
                                                  color: emeraldGreen,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              const Icon(Icons.king_bed, color: darkGreen, size: 24),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Bedrooms: ${acc['numBedrooms'] ?? 'N/A'}',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: darkSlateGray,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on, color: darkGreen, size: 24),
                                              const SizedBox(width: 10),
                                              Text(
                                                'State: ${acc['state'] ?? 'N/A'}',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: darkSlateGray,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(Icons.person, color: darkGreen, size: 24),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Seller: ${acc['seller'] ?? 'N/A'}',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: darkSlateGray,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(Icons.group, color: darkGreen, size: 24),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Shared: ${acc['shared_or_not'] == '1' ? 'Shared' : 'Not shared'}',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: darkSlateGray,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(Icons.square_foot, color: darkGreen, size: 24),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Size: ${acc['propertySize_m'] ?? 'N/A'} m²',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: darkSlateGray,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(Icons.directions_walk, color: darkGreen, size: 24),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Distance: ${acc['sph_dist'] ?? 'N/A'} km',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: darkSlateGray,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today, color: darkGreen, size: 24),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Days on site: ${acc['days_on_site'] ?? 'N/A'}',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      color: darkSlateGray,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            _getFirstParagraph(acc['description']),
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: mediumGrey,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: warmGold.withOpacity(0.2),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: mediumGrey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BounceInDown(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: _currentPage > 0
                            ? () => setState(() => _currentPage--)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: emeraldGreen,
                          foregroundColor: whiteColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text('Previous'),
                      ),
                    ),
                    Text(
                      'Page ${_currentPage + 1} of ${((accommodations.length - 1) ~/ _itemsPerPage) + 1}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: darkSlateGray,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    BounceInDown(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: endIndex < accommodations.length
                            ? () => setState(() => _currentPage++)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: emeraldGreen,
                          foregroundColor: whiteColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text('Next'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}