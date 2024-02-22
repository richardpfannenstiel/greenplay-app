import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenplay/models/station/station_status.dart';
import 'package:greenplay/viewmodels/station/station_selection_view_model.dart';

import '../../../models/gadget/gadget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../services/directions_service.dart';
import '../detail/gadget_cell_view.dart';

class StationSelectionView extends StatefulWidget {
  final StationSelectionViewModel viewModel;
  const StationSelectionView({
    super.key,
    required this.viewModel,
  });

  @override
  State<StationSelectionView> createState() => _StationSelectionViewState();
}

class _StationSelectionViewState extends State<StationSelectionView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _stationDescription,
          Divider(
              height: 30,
              thickness: 0.5,
              indent: 0,
              endIndent: 0,
              color: Theme.of(context).dividerColor),
          if (widget.viewModel.station.status == StationStatus.available) ...[
            _gadgets,
            const Spacer(),
            _detailsButton,
            const Spacer(),
          ] else ...[
            const Spacer(),
            Row(
              children: const [
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(CupertinoIcons.exclamationmark_circle_fill,
                      color: Colors.red, size: 50),
                ),
                Spacer(),
              ],
            ),
            Text(
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
                AppLocalizations.of(context)!.stationClosedDescription),
            const Spacer(),
            const Spacer(),
          ]
        ],
      ),
    );
  }

  Widget get _stationDescription {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.viewModel.station.name ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            FutureBuilder<double>(
                future: widget.viewModel.estimateDistance(context),
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(AppLocalizations.of(context)!.lockerStation,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16));
                  } else {
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return Text(
                            "${snapshot.data!.toStringAsFixed(1)}km ${AppLocalizations.of(context)!.away}",
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16));
                      }
                    }
                    return Text(AppLocalizations.of(context)!.lockerStation);
                  }
                }),
          ],
        ),
        const Spacer(),
        CupertinoButton(
            padding: EdgeInsets.zero,
            child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, shape: BoxShape.circle),
                child: Icon(CupertinoIcons.map_fill,
                    color: Theme.of(context).primaryColor, size: 25)),
            onPressed: () {
              HapticFeedback.selectionClick();
              DirectionsService.shared.launchMaps(
                  widget.viewModel.station.lat, widget.viewModel.station.lon);
            }),
      ],
    );
  }

  Widget get _gadgets {
    return FutureBuilder<List<Gadget>>(
        future: widget.viewModel.fetchGadgets(),
        builder: (BuildContext context, AsyncSnapshot<List<Gadget>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _gadgetsLoadingView;
          } else {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return Column(
                    children: snapshot.data!
                        .map((gadget) => GadgetCellView(gadget: gadget))
                        .toList());
              }
            }
            return const Text("");
          }
        });
  }

  Widget get _gadgetsLoadingView {
    return Row(
      children: [
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
              child:
                  CupertinoActivityIndicator(radius: 20.0, color: Colors.green),
            ),
            Text(AppLocalizations.of(context)!.loadingAvailableGadgets,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16)),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget get _detailsButton {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      child: CupertinoButton(
          onPressed:
              (widget.viewModel.station.status == StationStatus.available)
                  ? (() {
                      widget.viewModel.showStationDetails(context);
                    })
                  : null,
          color: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 10),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(AppLocalizations.of(context)!.loadMoreGadgets,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white)))),
    );
  }
}
