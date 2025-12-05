import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gas_app_project_dev/services/auth.dart';
import 'package:gas_app_project_dev/services/gas_station.dart';
import 'package:gas_app_project_dev/services/gas_station_services.dart';
import 'package:gas_app_project_dev/services/gas_filter_tab.dart';
import 'package:gas_app_project_dev/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchScreen extends StatefulWidget {
  final bool isDarkMode;
  const SearchScreen({super.key, required this.isDarkMode});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GasStationServices firestoreService = GasStationServices();

  final TextEditingController doubleController = TextEditingController();

  final TextEditingController stationController = TextEditingController();

  Position? _userPosition;

  String _searchQuery = '';

  String role = 'user';

  bool _loadingRole = true;

  GasStation? selectedStation;

  List<Map<String, dynamic>> nearbyStations = [];

  Map<String, dynamic> _filters = {'maxDistance': 25.0, 'sort': 'distance_asc'};

  @override
  void initState() {
    super.initState();
    getUserLocation();
    getUserRole();
  }
  //Calls function from "location_service.dart" to get user location
  void getUserLocation() async {
    try {
      final locationSerive = LocationService();
      final pos = await locationSerive.getCurrentLocation();

      setState(() {
        _userPosition = pos;
        print('User Location Found');
      });
    } catch (e) {
      print('Error getting location $e');
    }
  }
  //Calls from firebase to get the user's role
  void getUserRole() async {
    final User? user = Auth().currentUser;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    setState(() {
      role = userDoc.data()?['role'] ?? 'user';
      _loadingRole = false;
    });
  }
  //If user is a contributor, allows user to post contribution to firebase
  Future<void> addContribution({
    required String address,
    required double price,
  }) async {
    try {
      final User? user = Auth().currentUser;

      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('contributions')
          .add({
            'address': address,
            'price': price,
            'timestamp': FieldValue.serverTimestamp(),
            'lat': _userPosition!.latitude,
            'long': _userPosition!.longitude,
          });
    } catch (e) {
      print('Contribution failed to save');
    }
  }
  //Opens dialog for contribution
  void openPriceBox({
    String? placeId,
    String? currentStation,
    double? currentPrice,
  }) {
    // Pre-fill controllers when updating
    final isDark = widget.isDarkMode;
    selectedStation = null;
    if (placeId != null) {
      stationController.text = currentStation ?? "";
      doubleController.text = currentPrice?.toString() ?? "";
    } else {
      stationController.clear();
      doubleController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? darkCard : lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isDark ? darkBorder : lightBorder, width: 2),
        ),

        title: Text(
          "Update Gas Price",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? darkTextPrimary : lightText,
          ),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (placeId == null)
              Container(
                decoration: BoxDecoration(
                  color: isDark ? darkBackground : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? darkBorder : lightBorder,
                    width: 1.5,
                  ),
                ),
                child: DropdownButtonFormField<GasStation>(
                  isExpanded: true,
                  initialValue: selectedStation,

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? darkBackground : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? darkBorder : lightBorder,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? darkAccent : lightAccent,
                        width: 2,
                      ),
                    ),
                  ),
                  hint: Text(
                    "Select Gas Station",
                    style: TextStyle(
                      color: isDark ? darkTextSecondary : Colors.grey[600],
                    ),
                  ),
                  items: nearbyStations.map((entry) {
                    final station = entry['station'] as GasStation;
                    return DropdownMenuItem<GasStation>(
                      value: station,
                      child: Text(
                        station.address,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (station) {
                    setState(() {
                      selectedStation = station;
                    });
                  },
                ),
              ),

            const SizedBox(height: 16),
            TextField(
              controller: doubleController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: "Enter Price, e.g., 4.29",
                filled: true,
                fillColor: isDark ? darkBackground : Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark ? darkBorder : lightBorder,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark ? darkAccent : lightAccent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),

        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final address = placeId != null
                    ? stationController.text
                    : selectedStation?.address;
                if (address == null) return;
                final price =
                    double.tryParse(doubleController.text.trim()) ?? 0.0;

                await addContribution(address: address, price: price);

                doubleController.clear();
                selectedStation = null;

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? darkAccent : lightAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Update"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? darkBackground : lightBackground,
      appBar: AppBar(
        backgroundColor: widget.isDarkMode ? darkCard : lightCard,
        elevation: 0,
        title: Text(
          "Gas Prices",
          style: TextStyle(
            color: widget.isDarkMode ? darkTextPrimary : lightText,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: widget.isDarkMode ? darkTextPrimary : lightText,
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/filter-svgrepo-com.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                widget.isDarkMode ? darkTextPrimary : lightText,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () async {
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                builder: (_) => FilterSheet(
                  currentFilters: _filters,
                  onApply: (newFilters) {}, // <-- KEEP EMPTY OR REMOVE
                ),
              );
              if (result != null) {
                setState(() {
                  _filters = result;
                });
              }
            },
          ),
        ],
      ),
      floatingActionButton: !_loadingRole && role == 'contributor'
          ? FloatingActionButton(
              onPressed: openPriceBox,
              backgroundColor: isDark ? darkAccent : lightAccent,
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16, left: 20, right: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? darkBackground : lightBackground,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: isDark ? darkBorder : lightBorder,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: isDark ? darkAccent : lightAccent,
                    width: 2,
                  ),
                ),

                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getGasInfo(),
              key: ValueKey(_filters),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final stationList = snapshot.data!.docs;
                  final filter = StationFilter();

                  final filteredStations = stationList.where((doc) {
                    if (_userPosition == null) return false;
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    final addy = (data['address'] ?? '')
                        .toString()
                        .toLowerCase();
                    final distance =
                        filter.calculateDistance(
                          _userPosition!.latitude,
                          _userPosition!.longitude,
                          data['latitude'],
                          data['longitude'],
                        ) *
                        0.621371;
                    final matchesSearch =
                        _searchQuery.isEmpty ||
                        name.contains(_searchQuery) ||
                        addy.contains(_searchQuery);
                    final withinDistance = distance <= _filters['maxDistance'];

                    return withinDistance & matchesSearch;
                  }).toList();

                  if (_filters['sort'] == 'price_asc') {
                    filteredStations.sort((a, b) {
                      final dataA = a.data() as Map<String, dynamic>;
                      final dataB = b.data() as Map<String, dynamic>;
                      final pa = (dataA['price'] as num?)?.toDouble() ?? 0.0;
                      final pb = (dataB['price'] as num?)?.toDouble() ?? 0.0;
                      return pa.compareTo(pb);
                    });
                  } else if (_filters['sort'] == 'price_desc') {
                    filteredStations.sort((a, b) {
                      final dataA = a.data() as Map<String, dynamic>;
                      final dataB = b.data() as Map<String, dynamic>;
                      final pa = (dataA['price'] as num?)?.toDouble() ?? 0.0;
                      final pb = (dataB['price'] as num?)?.toDouble() ?? 0.0;
                      return pb.compareTo(pa);
                    });
                  } else if (_filters['sort'] == 'distance_desc') {
                    filteredStations.sort((a, b) {
                      final dataA = a.data() as Map<String, dynamic>;
                      final dataB = b.data() as Map<String, dynamic>;
                      final da = filter.calculateDistance(
                        _userPosition!.latitude,
                        _userPosition!.longitude,
                        dataA['latitude'],
                        dataA['longitude'],
                      );
                      final db = filter.calculateDistance(
                        _userPosition!.latitude,
                        _userPosition!.longitude,
                        dataB['latitude'],
                        dataB['longitude'],
                      );
                      return db.compareTo(da);
                    });
                  } else {
                    filteredStations.sort((a, b) {
                      final dataA = a.data() as Map<String, dynamic>;
                      final dataB = b.data() as Map<String, dynamic>;
                      final da = filter.calculateDistance(
                        _userPosition!.latitude,
                        _userPosition!.longitude,
                        dataA['latitude'],
                        dataA['longitude'],
                      );
                      final db = filter.calculateDistance(
                        _userPosition!.latitude,
                        _userPosition!.longitude,
                        dataB['latitude'],
                        dataB['longitude'],
                      );
                      return da.compareTo(db);
                    });
                  }

                  nearbyStations = filteredStations.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final station = GasStation.fromFirestore(data, doc.id);
                    return {'station': station};
                  }).toList();

                  // Display list
                  return ListView.builder(
                    itemCount: filteredStations.length,
                    itemBuilder: (context, index) {
                      final document = filteredStations[index];
                      final data =
                          document.data()
                              as Map<String, dynamic>; // fixed syntax
                      final stationText = data['name'] ?? 'Unknown Station';
                      final address = data['address'] ?? 'Unknown Address';
                      final price = (data['price'] as num?)?.toDouble() ?? 0.0;
                      final distance =
                          filter.calculateDistance(
                            _userPosition!.latitude,
                            _userPosition!.longitude,
                            data['latitude'],
                            data['longitude'],
                          ) *
                          0.621371;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? darkCard : lightCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? darkBorder : lightBorder,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    stationText,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? darkTextPrimary
                                          : lightText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '\$${price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? darkTextPrimary
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),
                            Text(
                              address,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? darkTextSecondary
                                    : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${distance.toStringAsFixed(2)} mi',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? darkTextSecondary
                                    : Colors.black54,
                              ),
                            ),

                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final encodedAddress = Uri.encodeComponent(
                                      address,
                                    );
                                    final googleMapsUrl = Uri.parse(
                                      "https://www.google.com/maps/search/?api=1&query=$encodedAddress",
                                    );

                                    if (!await launchUrl(
                                      googleMapsUrl,
                                      mode: LaunchMode.externalApplication,
                                    )) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Could not open maps"),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDark
                                        ? darkAccent
                                        : lightAccent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Go"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
