import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenplay/models/map/map_sheet_state.dart';
import 'package:greenplay/viewmodels/composite_view_model.dart';
import 'package:greenplay/views/account/login_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/gadget/gadget.dart';
import '../../models/station/station.dart';
import '../../services/mqtt_service.dart';
import '../../viewmodels/rental/active_rental_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectRentalItemViewModel extends ChangeNotifier {
  bool waitingForLocker = false;

  final MQTTService mqttService = MQTTService();

  void backAction(BuildContext context) {
    HapticFeedback.selectionClick();
    provider.Provider.of<CompositeViewModel>(context, listen: false)
        .recoverLastSheetState();
  }

  void observeLocker(BuildContext context) {
    final Station? station =
        provider.Provider.of<CompositeViewModel>(context, listen: false)
            .selectedStation;
    final Gadget? gadget =
        provider.Provider.of<CompositeViewModel>(context, listen: false)
            .selectedGadget;
    mqttService.connect().then((value) => mqttService.subscribe(
            'station/${station!.id}/lock/${gadget!.lockerID}/state', (content) {
          if (content == 'OPEN') {
            provider.Provider.of<ActiveRentalViewModel>(context, listen: false)
                .setRentalActive();
            provider.Provider.of<CompositeViewModel>(context, listen: false)
                .setSheetState(MapSheetState.vanished);
            HapticFeedback.heavyImpact();
          }
        }));
  }

  void startRental(BuildContext context) {
    if (Supabase.instance.client.auth.currentUser == null) {
      showCupertinoModalBottomSheet(
          context: context, builder: (context) => const LoginView());
      return;
    }
    provider.Provider.of<ActiveRentalViewModel>(context, listen: false)
        .startRental(context)
        .then((value) {
      if (value) {
        waitingForLocker = true;
        notifyListeners();
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Text(
              AppLocalizations.of(context)!.error,
              textAlign: TextAlign.center,
            ),
            content: Text(
              AppLocalizations.of(context)!.startRentalError,
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: <Widget>[
              CupertinoButton(
                  child: Text(
                    AppLocalizations.of(context)!.dismiss,
                  ),
                  onPressed: () {
                    backAction(context);
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      }
    });
  }
}
