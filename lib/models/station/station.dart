import 'package:greenplay/models/station/station_status.dart';

class Station {
  static Station mock = const Station(
      id: 42, lat: 48.14828, lon: 11.56996, status: StationStatus.unavailable);

  final int id;
  final double lat;
  final double lon;
  final String? name;
  final StationStatus status;

  const Station(
      {required this.id,
      required this.lat,
      required this.lon,
      this.name,
      required this.status});

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
        id: json['ID'],
        lat: json['latitude'],
        lon: json['longitude'],
        name: json["name"],
        status: StationStatusExtension.fromString(json["stationStatus"]));
  }
}
