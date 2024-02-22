import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenplay/models/rental/rental.dart';
import 'package:greenplay/viewmodels/composite_view_model.dart';
import 'package:greenplay/viewmodels/rental/select_rental_item_view_model.dart';
import 'package:greenplay/views/components/rental_cell.dart';
import 'package:provider/provider.dart';

import '../../models/gadget/gadget.dart';
import '../../models/station/station.dart';
import '../../viewmodels/rental/active_rental_view_model.dart';
import '../components/payment_cell.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectRentalItem extends StatefulWidget {
  const SelectRentalItem({super.key});

  @override
  State<SelectRentalItem> createState() => _SelectRentalItemState();
}

class _SelectRentalItemState extends State<SelectRentalItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _rentalOverview,
          const Spacer(),
          _actionView,
          const Spacer(),
          _rentButton,
        ],
      ),
    );
  }

  Widget get _rentalOverview {
    final bool waitingForLocker =
        Provider.of<SelectRentalItemViewModel>(context).waitingForLocker;
    final Station? station =
        Provider.of<CompositeViewModel>(context, listen: false).selectedStation;
    final Gadget? gadget =
        Provider.of<CompositeViewModel>(context, listen: false).selectedGadget;
    return RentalCell(
        backAction: () => waitingForLocker
            ? null
            : Provider.of<SelectRentalItemViewModel>(context, listen: false)
                .backAction(context),
        lockerName: station?.name ?? "",
        item: gadget?.type ?? "");
  }

  Widget get _actionView {
    final bool waitingForLocker =
        Provider.of<SelectRentalItemViewModel>(context).waitingForLocker;
    return waitingForLocker
        ? const Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
            child:
                CupertinoActivityIndicator(radius: 20.0, color: Colors.green),
          )
        : const PaymentCell();
  }

  Widget get _rentButton {
    final screenSize = MediaQuery.of(context).size;
    final Rental? activeRental =
        Provider.of<ActiveRentalViewModel>(context, listen: false).activeRental;
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: CupertinoButton(
          onPressed: (activeRental != null)
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  Provider.of<SelectRentalItemViewModel>(context, listen: false)
                      .observeLocker(context);
                  Provider.of<SelectRentalItemViewModel>(context, listen: false)
                      .startRental(context);
                },
          color: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          child: Container(
              width: screenSize.width,
              alignment: Alignment.center,
              child: activeRental != null
                  ? (activeRental.active
                      ? Text(
                          AppLocalizations.of(context)!.activeRentalInProgress,
                          style: const TextStyle(color: Colors.grey))
                      : Text(AppLocalizations.of(context)!.lockOpens,
                          style: const TextStyle(color: Colors.grey)))
                  : Text(AppLocalizations.of(context)!.startRental,
                      style: const TextStyle(color: Colors.white)))),
    );
  }
}
