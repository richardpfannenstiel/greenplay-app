import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenplay/viewmodels/station/station_detail_view_model.dart';
import 'package:greenplay/views/station/detail/gadget_cell_view.dart';
import '../../../models/gadget/gadget.dart';
import '../../components/circular_button.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StationDetailView extends StatefulWidget {
  final StationDetailViewModel viewModel;
  const StationDetailView({
    super.key,
    required this.viewModel,
  });

  @override
  State<StationDetailView> createState() => _StationDetailViewState();
}

class _StationDetailViewState extends State<StationDetailView> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          width: screenSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _stationDescription,
                  const Spacer(),
                  RotatedBox(
                    quarterTurns: 3,
                    child: CircularButton(
                        callback: () =>
                            widget.viewModel.dismissStationDetails(context)),
                  )
                ],
              ),
              Text(
                AppLocalizations.of(context)!.lockerStation,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16),
              ),
              Divider(
                  height: 30,
                  thickness: 0.5,
                  indent: 0,
                  endIndent: 0,
                  color: Theme.of(context).dividerColor),
              _gadgets,
              const Spacer(),
            ],
          ),
        ));
  }

  Widget get _gadgets {
    final screenSize = MediaQuery.of(context).size;
    return FutureBuilder<List<Gadget>>(
        future: widget.viewModel.fetchGadgets(widget.viewModel.station),
        builder: (BuildContext context, AsyncSnapshot<List<Gadget>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _gadgetsLoadingView;
          } else {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return SizedBox(
                    height: screenSize.height * 0.7,
                    child: SingleChildScrollView(
                        child: Column(
                            children: snapshot.data!
                                .map((gadget) => GadgetCellView(gadget: gadget))
                                .toList())));
              }
            }
            return _gadgetsLoadingFailedView;
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

  Widget get _gadgetsLoadingFailedView {
    return Row(
      children: [
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
              child: Icon(CupertinoIcons.exclamationmark_circle,
                  color: Colors.red, size: 50),
            ),
            Text(AppLocalizations.of(context)!.failedToLoadGadgets,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16)),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Widget get _stationDescription {
    return Row(
      children: [
        Text(
          widget.viewModel.station.name ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ],
    );
  }
}
