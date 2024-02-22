import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/map_view_model.dart';

class CurrentLocationButton extends StatelessWidget {
  const CurrentLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: RawMaterialButton(
        fillColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        shape: const CircleBorder(),
        onPressed: (Provider.of<MapViewModel>(context, listen: false)
                .isFetchingCurrentLocation)
            ? null
            : () => {
                  Provider.of<MapViewModel>(context, listen: false)
                      .navigateToCurrentLocation(context)
                },
        child: (Provider.of<MapViewModel>(context).isFetchingCurrentLocation)
            ? CupertinoActivityIndicator(
                radius: 10.0,
                color: Theme.of(context).primaryColor,
              )
            : Icon(CupertinoIcons.location_fill,
                color: Theme.of(context).primaryColor, size: 30),
      ),
    );
  }
}
