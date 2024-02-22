import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenplay/models/station/station_status.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../models/map/map_sheet_state.dart';
import '../models/station/station.dart';
import '../services/communication_service.dart';
import '../services/server_url.dart';

import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;

import 'composite_view_model.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel() {
    _fetchStations();
  }

  BitmapDescriptor? availablePinIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor? unavailablePinIcon = BitmapDescriptor.defaultMarker;

  List<Station> _stations = [];

  List<Station> get stations => _stations;

  PlatformMapController? controller;

  bool _isFetchingNearbyStation = false;
  bool get isFetchingNearbyStation => _isFetchingNearbyStation;

  bool _isFetchingCurrentLocation = false;
  bool get isFetchingCurrentLocation => _isFetchingCurrentLocation;

  void loadCustomMapPins() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.5),
            'assets/locker_available.png')
        .then((d) {
      availablePinIcon = d;
    });
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.5),
            'assets/locker_unavailable.png')
        .then((d) {
      unavailablePinIcon = d;
    });
  }

  void _fetchStations() async {
    final response =
        await CommunicationService.shared.get(ServerURL.stations.path());
    Iterable body = jsonDecode(response.body);
    _stations = List<Station>.from(
        body.map((stationBody) => Station.fromJson(stationBody)));
    notifyListeners();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> fetchNearestStation(BuildContext context) async {
    HapticFeedback.selectionClick();
    _isFetchingNearbyStation = true;
    notifyListeners();

    Location location = Location();

    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var locationData = await location.getLocation();

    var closestStation = stations.reduce(
      (value, element) {
        var oldStationDistance = calculateDistance(value.lat, value.lon,
            locationData.latitude, locationData.longitude);
        var newStationDistance = calculateDistance(element.lat, element.lon,
            locationData.latitude, locationData.longitude);
        if (newStationDistance < oldStationDistance &&
            element.status == StationStatus.available) return element;
        return value;
      },
    );

    controller!.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(closestStation.lat - 0.005, closestStation.lon), 14));
    // ignore: use_build_context_synchronously
    Provider.of<CompositeViewModel>(context, listen: false)
        .setSheetState(MapSheetState.stationSelected);
    // ignore: use_build_context_synchronously
    Provider.of<CompositeViewModel>(context, listen: false)
        .selectStation(closestStation);
    HapticFeedback.mediumImpact();
    _isFetchingNearbyStation = false;
    notifyListeners();
  }

  Future<void> navigateToCurrentLocation(BuildContext context) async {
    HapticFeedback.selectionClick();
    _isFetchingCurrentLocation = true;
    notifyListeners();
    Location location = Location();

    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var locationData = await location.getLocation();

    controller!.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(locationData.latitude!, locationData.longitude!), 14));
    HapticFeedback.mediumImpact();
    _isFetchingCurrentLocation = false;
    notifyListeners();
  }
}
