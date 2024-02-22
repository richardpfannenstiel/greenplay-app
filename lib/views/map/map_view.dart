import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenplay/models/station/station_status.dart';
import 'package:greenplay/viewmodels/map_view_model.dart';
import 'package:greenplay/views/map/current_location_button.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/map/map_sheet_state.dart';
import '../../models/station/station.dart';
import '../../viewmodels/composite_view_model.dart';

import '../account/profile_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapViewModel viewModel = MapViewModel();

  @override
  void initState() {
    viewModel.loadCustomMapPins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Station> stations = Provider.of<MapViewModel>(context).stations;
    return Stack(
      children: [
        PlatformMap(
            onMapCreated: (controller) {
              Provider.of<MapViewModel>(context, listen: false).controller =
                  controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(48.137154, 11.576124),
              zoom: 12,
            ),
            markers: Set<Marker>.of(stations.map<Marker>((station) => Marker(
                  markerId: MarkerId(station.lon.toString()),
                  position: LatLng(station.lat, station.lon),
                  consumeTapEvents: false,
                  icon: station.status == StationStatus.available
                      ? viewModel.availablePinIcon
                      : viewModel.unavailablePinIcon,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Provider.of<MapViewModel>(context, listen: false)
                        .controller
                        ?.hideMarkerInfoWindow(
                            MarkerId(station.lon.toString()));
                    Provider.of<MapViewModel>(context, listen: false)
                        .controller
                        ?.animateCamera(CameraUpdate.newLatLngZoom(
                            LatLng(station.lat - 0.005, station.lon), 14));
                    Provider.of<CompositeViewModel>(context, listen: false)
                        .setSheetState(MapSheetState.stationSelected);
                    Provider.of<CompositeViewModel>(context, listen: false)
                        .selectStation(station);
                  },
                ))),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            onTap: (location) {
              Provider.of<CompositeViewModel>(context, listen: false)
                  .dismissSheet();
            },
            onCameraMove: (cameraUpdate) {
              Provider.of<CompositeViewModel>(context, listen: false)
                  .dismissSheet();
            },
            compassEnabled: true),
        Positioned(bottom: 50, child: _mapButtons)
      ],
    );
  }

  Widget get _mapButtons {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: const [Spacer(), CurrentLocationButton()],
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: RawMaterialButton(
                        highlightColor: Theme.of(context).backgroundColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        onPressed:
                            (Provider.of<MapViewModel>(context, listen: false)
                                    .isFetchingNearbyStation)
                                ? null
                                : () {
                                    Provider.of<MapViewModel>(context,
                                            listen: false)
                                        .fetchNearestStation(context);
                                  },
                        fillColor: Theme.of(context).backgroundColor,
                        child: (Provider.of<MapViewModel>(context,
                                    listen: false)
                                .isFetchingNearbyStation)
                            ? CupertinoActivityIndicator(
                                radius: 10.0,
                                color: Theme.of(context).hintColor)
                            : Text(
                                AppLocalizations.of(context)!.findNearbyStation,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const ProfileIcon()
                ])
          ],
        ),
      ),
    );
  }
}
