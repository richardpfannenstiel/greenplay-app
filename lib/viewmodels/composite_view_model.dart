import 'package:flutter/material.dart';
import 'package:greenplay/models/sheet_positions.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../../models/station/station.dart';
import '../models/gadget/gadget.dart';
import '../models/map/map_sheet_state.dart';

class CompositeViewModel extends ChangeNotifier {
  final _sheetController = SnappingSheetController();

  SnappingSheetController get sheetController => _sheetController;
  List<SnappingPosition> get sheetPositions => [
        SheetPosition.zero,
        SheetPosition.bottom,
        SheetPosition.half,
        SheetPosition.full
      ];

  MapSheetState _sheetState = MapSheetState.vanished;
  MapSheetState get sheetState => _sheetState;

  MapSheetState _lastSheetState = MapSheetState.vanished;
  MapSheetState get lastSheetState => _lastSheetState;

  Station? _selectedStation;
  Station? get selectedStation => _selectedStation;

  Gadget? _selectedGadget;
  Gadget? get selectedGadget => _selectedGadget;

  void selectStation(Station station) {
    _selectedStation = station;
    notifyListeners();
  }

  void selectGadget(Gadget gadget) {
    _selectedGadget = gadget;
    notifyListeners();
  }

  void rentalFinished() {
    setSheetState(MapSheetState.rentalFinished);
  }

  void dismissSheet() {
    if (sheetState != MapSheetState.vanished) {
      setSheetState(MapSheetState.vanished);
    }
  }

  void setSheetState(MapSheetState state) {
    _lastSheetState = sheetState;
    _sheetState = state;
    switch (state) {
      case MapSheetState.vanished:
        _sheetController.snapToPosition(SheetPosition.zero);
        break;
      case MapSheetState.search:
        _sheetController.snapToPosition(SheetPosition.bottom);
        break;
      case MapSheetState.stationSelected:
        _sheetController.snapToPosition(SheetPosition.half);
        break;
      case MapSheetState.stationDetails:
        _sheetController.snapToPosition(SheetPosition.full);
        break;
      case MapSheetState.gadgetSelected:
        _sheetController.snapToPosition(SheetPosition.half);
        break;
      case MapSheetState.returnGadget:
        _sheetController.snapToPosition(SheetPosition.full);
        break;
      case MapSheetState.rentalFinished:
        _sheetController.snapToPosition(SheetPosition.half);
        break;
    }
    notifyListeners();
  }

  void recoverLastSheetState() {
    setSheetState(lastSheetState);
  }
}
