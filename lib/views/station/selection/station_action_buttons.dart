import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:greenplay/services/directions_service.dart';

import 'package:provider/provider.dart';

import '../../../viewmodels/composite_view_model.dart';

// ignore: import_of_legacy_library_into_null_safe

class StationActionButtons extends StatelessWidget {
  const StationActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var station = Provider.of<CompositeViewModel>(context, listen: false)
        .selectedStation!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: screenSize.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CupertinoButton(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            shape: BoxShape.circle),
                        child: const Icon(CupertinoIcons.map,
                            color: Colors.blue, size: 20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        AppLocalizations.of(context)!.showDirections,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16),
                      ),
                    )
                  ],
                ),
                onPressed: () => DirectionsService.shared
                    .launchMaps(station.lat, station.lon)),
            Divider(
                height: 20,
                thickness: 0.5,
                indent: 50,
                endIndent: 0,
                color: Theme.of(context).dividerColor),
            CupertinoButton(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            shape: BoxShape.circle),
                        child: const Icon(CupertinoIcons.star_fill,
                            color: Colors.blue, size: 20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        AppLocalizations.of(context)!.saveFavorite,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16),
                      ),
                    )
                  ],
                ),
                onPressed: () {}),
            Divider(
                height: 20,
                thickness: 0.5,
                indent: 50,
                endIndent: 0,
                color: Theme.of(context).dividerColor),
            CupertinoButton(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            shape: BoxShape.circle),
                        child: const Icon(
                            CupertinoIcons.exclamationmark_bubble_fill,
                            color: Colors.blue,
                            size: 20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        AppLocalizations.of(context)!.reportProblem,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16),
                      ),
                    )
                  ],
                ),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
