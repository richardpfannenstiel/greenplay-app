import 'package:flutter/material.dart';
import 'package:greenplay/viewmodels/composite_view_model.dart';
import 'package:greenplay/viewmodels/rental/active_rental_view_model.dart';
import 'package:greenplay/views/map/map_view.dart';
import 'package:greenplay/views/rental/active_rental_notification.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import '../viewmodels/map_view_model.dart';
import 'map/map_sheet_view.dart';

class CompositeView extends StatefulWidget {
  const CompositeView({super.key});

  @override
  State<CompositeView> createState() => _CompositeViewState();
}

class _CompositeViewState extends State<CompositeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(alignment: Alignment.center, children: [
      SnappingSheet(
        controller: Provider.of<CompositeViewModel>(context, listen: false)
            .sheetController,
        snappingPositions:
            Provider.of<CompositeViewModel>(context, listen: false)
                .sheetPositions,
        grabbingHeight: 75,
        sheetBelow: SnappingSheetContent(
            draggable: false,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: const MapSheetView(),
            )),
        child: ChangeNotifierProvider(
          create: ((context) => MapViewModel()),
          child: const MapView(),
        ),
      ),
      AnimatedPositioned(
        top: Provider.of<ActiveRentalViewModel>(context).showingActiveRentalPill
            ? 55
            : -140,
        duration: const Duration(milliseconds: 300),
        child: const ActiveRentalNotification(),
      ),
    ]));
  }
}
