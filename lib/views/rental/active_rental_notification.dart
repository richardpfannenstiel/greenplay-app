import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenplay/models/map/map_sheet_state.dart';
import 'package:greenplay/viewmodels/composite_view_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/rental/rental.dart';
import '../../viewmodels/rental/active_rental_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../account/login_view.dart';

class ActiveRentalNotification extends StatefulWidget {
  const ActiveRentalNotification({super.key});

  @override
  State<ActiveRentalNotification> createState() =>
      _ActiveRentalNotificationState();
}

class _ActiveRentalNotificationState extends State<ActiveRentalNotification> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      width: MediaQuery.of(context).size.width - 20,
      height:
          provider.Provider.of<ActiveRentalViewModel>(context, listen: false)
              .activeRentalPillHeight,
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _activityBar,
              ),
              const Spacer(),
              provider.Provider.of<ActiveRentalViewModel>(context,
                          listen: false)
                      .showingCloseLockerNotification
                  ? _closeDoorReminder
                  : Container(),
              const Spacer()
            ],
          )),
    );
  }

  Widget get _closeDoorReminder {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(CupertinoIcons.exclamationmark_circle_fill,
                  color: Colors.red, size: 25),
            ),
            const Spacer(),
            Text(AppLocalizations.of(context)!.closeLockerReminder,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                )),
            const Spacer()
          ],
        ));
  }

  Widget get _activityBar {
    Duration elapsed =
        provider.Provider.of<ActiveRentalViewModel>(context).elapsed;
    Rental rental =
        provider.Provider.of<ActiveRentalViewModel>(context).activeRental ??
            Rental.mock;
    return Row(
      children: <Widget>[
        SizedBox(
            width: 125,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(
                      'assets/gadgets/${rental.gadget.type.toLowerCase()}.png'),
                  width: 24,
                  height: 24,
                ),
                Text(
                  rental.gadget.type,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Colors.grey),
                ),
              ],
            )),
        const Spacer(),
        Text(
            "${elapsed.inMinutes}:${elapsed.inSeconds.remainder(60).toString().padLeft(2, '0')}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        const Spacer(),
        SizedBox(
          width: 125,
          child: CupertinoButton(
              onPressed: () => showConfirmReturnDialog(),
              color: Colors.green,
              padding: const EdgeInsets.all(10),
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              child: Text(
                AppLocalizations.of(context)!.returnGadget,
                style: const TextStyle(color: Colors.white),
              )),
        )
      ],
    );
  }

  void returnGadget() {
    provider.Provider.of<ActiveRentalViewModel>(context, listen: false)
        .requestStopRental(context)
        .then((value) => {
              if (value)
                {
                  provider.Provider.of<CompositeViewModel>(context,
                          listen: false)
                      .setSheetState(MapSheetState.returnGadget)
                }
              else
                {showErrorDialog()}
            });
  }

  void showConfirmReturnDialog() {
    HapticFeedback.selectionClick();
    if (Supabase.instance.client.auth.currentUser == null) {
      showCupertinoModalBottomSheet(
          context: context, builder: (context) => const LoginView());
      return;
    }
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        title: Text(
          AppLocalizations.of(context)!.returnWarningHeader,
          textAlign: TextAlign.center,
        ),
        content: Text(
          AppLocalizations.of(context)!.returnWarningInfo,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: <Widget>[
          CupertinoButton(
              child: Text(
                AppLocalizations.of(context)!.cancel,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          CupertinoButton(
              child: Text(
                AppLocalizations.of(context)!.returnGadget,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                returnGadget();
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  void showErrorDialog() {
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
          AppLocalizations.of(context)!.serverNotReachable,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: <Widget>[
          CupertinoButton(
              child: Text(
                AppLocalizations.of(context)!.dismiss,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
