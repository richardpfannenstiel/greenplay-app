import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/gadget/gadget.dart';
import '../../viewmodels/composite_view_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentCell extends StatelessWidget {
  const PaymentCell({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    Gadget gadget = Provider.of<CompositeViewModel>(context, listen: false)
            .selectedGadget ??
        Gadget.mock;
    return Container(
      width: screenSize.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Column(children: [
        Row(children: [
          const Image(
            image: AssetImage('assets/payment/visa.png'),
            width: 46,
            height: 29,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Raiffeisen Visa Gold",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Credit Card (0000) Preferred",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios,
              color: Theme.of(context).hintColor, size: 24),
        ]),
        Divider(
            height: 20,
            thickness: 0.5,
            indent: 0,
            endIndent: 0,
            color: Theme.of(context).dividerColor),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.costs,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${(gadget.price * 30).toStringAsFixed(2)} EUR ${AppLocalizations.of(context)!.perHalfHour}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "(${gadget.price.toStringAsFixed(2)} EUR ${AppLocalizations.of(context)!.perMinute})",
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
