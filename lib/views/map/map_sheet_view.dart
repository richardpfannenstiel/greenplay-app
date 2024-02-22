import 'package:flutter/material.dart';
import 'package:greenplay/models/station/station.dart';
import 'package:greenplay/viewmodels/rental/select_rental_item_view_model.dart';
import 'package:greenplay/viewmodels/return/return_gadget_view_model.dart';
import 'package:greenplay/viewmodels/station/station_detail_view_model.dart';
import 'package:greenplay/viewmodels/station/station_selection_view_model.dart';
import 'package:greenplay/views/search/quick_select_gadgets_view.dart';
import 'package:greenplay/views/station/detail/station_detail_view.dart';
import 'package:provider/provider.dart';

import '../../models/map/map_sheet_state.dart';
import '../../viewmodels/composite_view_model.dart';
import '../rental/select_rental_item.dart';
import '../station/selection/station_selection_view.dart';
import 'package:greenplay/views/return/rental_finished_view.dart';
import 'package:greenplay/views/return/return_gadget_view.dart';

class MapSheetView extends StatefulWidget {
  const MapSheetView({super.key});

  @override
  State<MapSheetView> createState() => _MapSheetViewState();
}

class _MapSheetViewState extends State<MapSheetView> {
  @override
  Widget build(BuildContext context) {
    MapSheetState state = Provider.of<CompositeViewModel>(context).sheetState;
    Station station = (Provider.of<CompositeViewModel>(context, listen: false)
            .selectedStation ??
        Station.mock);
    switch (state) {
      case MapSheetState.vanished:
        return const Text("");
      case MapSheetState.search:
        return const QuickSelectGadgetsView();
      case MapSheetState.stationSelected:
        return StationSelectionView(
          viewModel: StationSelectionViewModel(station),
        );
      case MapSheetState.stationDetails:
        return StationDetailView(
          viewModel: StationDetailViewModel(station),
        );
      case MapSheetState.gadgetSelected:
        return ChangeNotifierProvider(
          create: ((context) => SelectRentalItemViewModel()),
          child: const SelectRentalItem(),
        );
      case MapSheetState.returnGadget:
        return ChangeNotifierProvider(
          create: ((context) => ReturnGadgetViewModel()),
          child: const ReturnGadgetView(),
        );
      case MapSheetState.rentalFinished:
        return const RentalFinishedView();
    }
  }
}
