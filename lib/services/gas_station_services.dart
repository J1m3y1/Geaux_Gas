import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:gas_app_project_dev/secrets.dart';


class GasStationServices {
  final CollectionReference gasstation = FirebaseFirestore.instance.collection("Station_Info");
  String get apiKey => API_KEY;
  
  //Gets gas information from firebase
  Stream<QuerySnapshot> getGasInfo() {
    return gasstation.snapshots();
  }

  //Aquires gas stations from firebase located near user location
  Future<List<dynamic>> fetchStations(
    double latitude, double longitude, {int radius = 50000}) async {
      
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
      '?location=$latitude,$longitude'
      '&radius=$radius'
      '&type=gas_station'
      '&key=$apiKey'
    );
      
      final response = await http.get(url);

      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        final stations = data['results'] as List<dynamic>;
        return stations;
      } else{
        throw Exception('Failed to fetch stations:${response.statusCode}');
      }
    }
}