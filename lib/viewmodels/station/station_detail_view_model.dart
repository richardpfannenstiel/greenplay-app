import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenplay/models/gadget/gadget.dart';
import 'package:greenplay/services/communication_service.dart';
import 'package:greenplay/services/server_url.dart';
import 'package:provider/provider.dart';
import '../../models/map/map_sheet_state.dart';
import '../../models/station/station.dart';
import '../composite_view_model.dart';

class StationDetailViewModel extends ChangeNotifier {
  final Station station;

  StationDetailViewModel(this.station);

  void dismissStationDetails(BuildContext context) {
    HapticFeedback.selectionClick();
    Provider.of<CompositeViewModel>(context, listen: false)
        .setSheetState(MapSheetState.stationSelected);
  }

  Future<List<Gadget>> fetchGadgets(Station station) async {
    final response = await CommunicationService.shared
        .get(ServerURL.gadgets.path(arguments: [station.id]));
    Iterable body = jsonDecode(response.body);

    List<Gadget> gadgets = List<Gadget>.from(
        body.map((gadgetBody) => Gadget.fromJson(gadgetBody)));
    return Future.value(gadgets);
  }
}
