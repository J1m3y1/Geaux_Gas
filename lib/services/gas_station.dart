class GasStation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double price;
  final String address;
  final String deals;

  GasStation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.address,
    required this.deals,
  });

  //Creates gas staion template
factory GasStation.fromFirestore(Map<String, dynamic> data, String documentId) {
  return GasStation(
    id: documentId,
    name: data['name'] ?? 'Unknown',
    latitude: (data['latitude'] ?? 0).toDouble(),
    longitude: (data['longitude'] ?? 0).toDouble(),
    price: (data['price'] ?? 0).toDouble(),
    address: data['address'] ?? 'No address provided',
    deals: data['deals'] ?? ''
  );
}

  void operator [](String other) {}
}