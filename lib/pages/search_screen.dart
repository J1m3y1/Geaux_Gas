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


   Map<String,dynamic> _filters = {
              'maxDistance': 25.0,
              'sort': 'distance_asc',
   };
  
  @override
  void initState() {
    super.initState();
    getUserLocation();
    getUserRole();
  }

   void getUserLocation() async {
    try{
      final locationSerive = LocationService();
      final pos = await locationSerive.getCurrentLocation();

      setState(() {
        _userPosition = pos;
        print('User Location Found');
      });
    } catch(e) {
      print('Error getting location $e');
    }
   }

   void getUserRole() async {
         final User? user = Auth().currentUser;

        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

        setState(() {
          role = userDoc.data()?['role'] ?? 'user';
          _loadingRole = false;
        });
   }

   Future<void> addContribution({
    required String address,
    required double price,
   }) async {
    try {
      final User? user = Auth().currentUser;

      if(user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('contributions').add({
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

  void openPriceBox({String? placeId, String? currentStation, double? currentPrice}) {
  // Pre-fill controllers when updating
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
    title: const Text("Update Gas Price"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Only allow editing station name when adding
        if (placeId == null)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300), // limit width inside dialog
            child: DropdownButtonFormField<GasStation>(
              isExpanded: true, // ensures the dropdown fills available width
              decoration: const InputDecoration(
                labelText: "Select Gas Station",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              value: selectedStation,
              items: nearbyStations.map((entry) {
                final station = entry['station'] as GasStation;
                return DropdownMenuItem<GasStation>(
                  value: station,
                  child: Text(
                    station.address,
                    overflow: TextOverflow.ellipsis, // truncate long addresses
                    maxLines: 1,
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
        const SizedBox(height: 12),
        TextField(
          controller: doubleController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: "Enter Price, e.g., 4.29",
          ),
        ),
      ],
    ),
    actions: [
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final address = placeId != null
                  ? stationController.text
                  : selectedStation?.address;
              if (address == null) return;
              final price = double.tryParse(doubleController.text.trim()) ?? 0.0;

              await addContribution(address: address, price: price);

              selectedStation = null;
              doubleController.clear();
              Navigator.of(context).pop();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    ],
  ),
);

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gas Prices"),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/filter-svgrepo-com.svg',
              width: 24,
              height: 24
            ),
            onPressed: () async{
              final result = await showModalBottomSheet<Map<String,dynamic>>(
                context: context,
                builder: (_) => FilterSheet(
                  currentFilters: _filters,
                  onApply: (newFilters) {
                  Navigator.of(context).pop(newFilters);
                },),
              );

              if(result != null){
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
          child: const Icon(Icons.add), 
          ) : null,
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Color(0xff1D1617).withOpacity(0.11),
                      blurRadius: 40,
                      spreadRadius: 0.0
                    ),
                  ],
                ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: widget.isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7),
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none
                  ),
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
                if(_userPosition == null) return false;
                final data = doc.data() as Map<String, dynamic>;
                final name = (data['name'] ?? '').toString().toLowerCase();
                final addy = (data['address']?? '').toString().toLowerCase();
                final distance = filter.calculateDistance(_userPosition!.latitude, _userPosition!.longitude, data['latitude'], data['longitude']) * 0.621371;
                final matchesSearch = _searchQuery.isEmpty || name.contains(_searchQuery) || addy.contains(_searchQuery);
                final withinDistance = distance <= _filters['maxDistance'];

                return withinDistance & matchesSearch;
            }).toList();

            if(_filters['sort'] == 'price_asc') {
              filteredStations.sort((a , b) {
                final dataA = a.data() as Map<String,dynamic>;
                final dataB = b.data() as Map<String,dynamic>;
                final pa = (dataA['price'] as num?)?.toDouble() ?? 0.0;
                final pb = (dataB['price'] as num?)?.toDouble() ?? 0.0;
                return pa.compareTo(pb);
              });
            } else if(_filters['sort'] == 'price_desc'){
              filteredStations.sort((a , b) {
                final dataA = a.data() as Map<String,dynamic>;
                final dataB = b.data() as Map<String,dynamic>;
                final pa = (dataA['price'] as num?)?.toDouble() ?? 0.0;
                final pb = (dataB['price'] as num?)?.toDouble() ?? 0.0;
                return pb.compareTo(pa);
              });
            } else if(_filters['sort'] == 'distance_desc'){
              filteredStations.sort((a, b) {
                final dataA = a.data() as Map<String,dynamic>;
                final dataB = b.data() as Map<String,dynamic>;
                final da = filter.calculateDistance(_userPosition!.latitude, _userPosition!.longitude, dataA['latitude'], dataA['longitude']);
                final db = filter.calculateDistance(_userPosition!.latitude, _userPosition!.longitude, dataB['latitude'], dataB['longitude']);
                return db.compareTo(da);
              });
            } else {
              filteredStations.sort((a, b) {
                final dataA = a.data() as Map<String,dynamic>;
                final dataB = b.data() as Map<String,dynamic>;
                final da = filter.calculateDistance(_userPosition!.latitude, _userPosition!.longitude, dataA['latitude'], dataA['longitude']);
                final db = filter.calculateDistance(_userPosition!.latitude, _userPosition!.longitude, dataB['latitude'], dataB['longitude']);
                return da.compareTo(db);
              });
            }

            nearbyStations = filteredStations.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final station = GasStation.fromFirestore(data, doc.id);
            return {
              'station': station,
              };
            }).toList();


            // Display list
            return ListView.builder(
              itemCount: filteredStations.length,
              itemBuilder: (context, index) {
              final document = filteredStations[index];
              final data = document.data() as Map<String, dynamic>; // fixed syntax
              final stationText = data['name'] ?? 'Unknown Station';
              final address = data['address'] ?? 'Unknown Address';
              final price = (data['price'] as num?)?.toDouble() ?? 0.0;
              final distance = filter.calculateDistance(_userPosition!.latitude, _userPosition!.longitude, data['latitude'], data['longitude']) * 0.621371;
              

            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(stationText, overflow: TextOverflow.ellipsis,),
                Text('\$${price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ]),
              subtitle: Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(address, overflow: TextOverflow.ellipsis,),
                Text('${distance.toStringAsFixed(2)} mi'),
                  ],
                ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Per Gallon'),
                ElevatedButton(
                  onPressed: () async{
                    final address = data['address'] ?? '';
                    final encodedAddress = Uri.encodeComponent(address);
                    final googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$encodedAddress");
                  
                    if(!await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication)){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Could not open maps"),)
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ), 
                  child: const Text('Go'),
                ),
                  ],
                ),
            ]),
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
