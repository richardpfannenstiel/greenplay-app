import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenplay/models/map/map_sheet_state.dart';
import 'package:greenplay/viewmodels/composite_view_model.dart';
import 'package:provider/provider.dart';

import '../../../models/gadget/gadget.dart';
import '../../components/circular_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GadgetCellView extends StatelessWidget {
  final Gadget gadget;
  const GadgetCellView({super.key, required this.gadget});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
          width: screenSize.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: gadget.available
                  ? () {
                      showSelectedGadgetView(context);
                    }
                  : null,
              child: Row(
                children: [
                  CircularImage(
                      imageString:
                          'assets/gadgets/${gadget.type.toLowerCase()}.png',
                      size: 20,
                      backgroundColor: Colors.green),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gadget.type,
                            style: TextStyle(
                                color: gadget.available
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 18),
                          ),
                          Text(
                            "${(gadget.price * 30).toStringAsFixed(2)} EUR ${AppLocalizations.of(context)!.perHalfHour}",
                            style: TextStyle(
                                color: gadget.available
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          ),
                        ],
                      )),
                  const Spacer(),
                  gadget.available
                      ? const Icon(Icons.arrow_forward_ios,
                          color: Colors.grey, size: 24)
                      : Text(
                          AppLocalizations.of(context)!.rentedOut,
                          style: const TextStyle(color: Colors.grey),
                        ),
                ],
              ))),
    );
  }

  void showSelectedGadgetView(BuildContext context) {
    HapticFeedback.selectionClick();
    Provider.of<CompositeViewModel>(context, listen: false)
        .setSheetState(MapSheetState.gadgetSelected);
    Provider.of<CompositeViewModel>(context, listen: false)
        .selectGadget(gadget);
  }
}
