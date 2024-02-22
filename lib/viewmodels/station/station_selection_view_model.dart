import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenplay/models/gadget/gadget.dart';
import 'package:greenplay/services/communication_service.dart';
import 'package:greenplay/services/server_url.dart';
import 'package:provider/provider.dart';
import '../../models/map/map_sheet_state.dart';
import '../../models/station/station.dart';

import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;

import '../composite_view_model.dart';

class StationSelectionViewModel extends ChangeNotifier {
  final Station station;

  bool _isFetchingDistance = false;
  bool get isFetchingDistance => _isFetchingDistance;

  StationSelectionViewModel(this.station);

  Future<List<Gadget>> fetchGadgets() async {
    final response = await CommunicationService.shared
        .get(ServerURL.gadgets.path(arguments: [station.id]));
    Iterable body = jsonDecode(response.body);

    List<Gadget> gadgets = List<Gadget>.from(
        body.map((gadgetBody) => Gadget.fromJson(gadgetBody)));
    return Future.value(gadgets.sublist(0, 2));
  }

  void showStationDetails(BuildContext context) {
    HapticFeedback.selectionClick();
    Provider.of<CompositeViewModel>(context, listen: false)
        .setSheetState(MapSheetState.stationDetails);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<double> estimateDistance(BuildContext context) async {
    _isFetchingDistance = true;
    notifyListeners();

    Location location = Location();

    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return 0;
      }
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return 0;
      }
    }

    var locationData = await location.getLocation();
    var distance = calculateDistance(station.lat, station.lon,
        locationData.latitude, locationData.longitude);

    _isFetchingDistance = false;
    notifyListeners();
    return distance;
  }
}
