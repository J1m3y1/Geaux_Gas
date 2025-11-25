import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'gas_station.dart';

class MapScreen extends StatefulWidget {
  final bool isDarkMode;
  const MapScreen({super.key, required this.isDarkMode});

  @override
  State<MapScreen> createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  List<GasStation> gasStations = [];
  Set<Marker> markers = {};
  // Example coordinate (LSU campus)
  final LatLng _center = const LatLng(30.4133, -91.1823);

  @override
  void initState() {
    super.initState();
    gasStations = getSampleGasStations();
    _createMarkers();
  }

void _showStationPopup(GasStation station) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Theme.of(context).colorScheme.surface,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              station.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              station.address,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Prices
            ...station.prices.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                "${e.key}: \$${e.value.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16),
              ),
            )),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

  void _createMarkers() {
  markers = gasStations.map((station) {
    return Marker(
      markerId: MarkerId(station.id),
      position: LatLng(station.latitude, station.longitude),
      infoWindow: const InfoWindow(),
      onTap: () {
        _showStationPopup(station);
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
  }).toSet();
}

  Future<void> _setMapStyle() async {
    String stylePath = widget.isDarkMode
        ? 'assets/map_styles/dark_map.json'
        : 'assets/map_styles/light_map.json';

    final String mapStyle = await rootBundle.loadString(stylePath);
    mapController.setMapStyle(mapStyle);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setMapStyle(); // set style immediately on creation
  }

  @override
  void didUpdateWidget(covariant MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      _setMapStyle(); // update style when theme changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}