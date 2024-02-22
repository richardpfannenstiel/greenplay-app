import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenplay/viewmodels/rental/active_rental_view_model.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/map/map_sheet_state.dart';
import '../../models/rental/rental.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../viewmodels/composite_view_model.dart';

class RentalFinishedView extends StatefulWidget {
  const RentalFinishedView({super.key});

  @override
  State<RentalFinishedView> createState() => _RentalFinishedViewState();
}

class _RentalFinishedViewState extends State<RentalFinishedView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool animate = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          width: screenSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.thankYou,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Divider(
                  height: 30,
                  thickness: 0.5,
                  indent: 0,
                  endIndent: 0,
                  color: Theme.of(context).dividerColor),
              _rentalSummary,
              const Spacer(),
              _doneButton,
              const Spacer(),
            ],
          ),
        ));
  }

  Widget get _rentalSummary {
    final screenSize = MediaQuery.of(context).size;
    Rental rental =
        Provider.of<ActiveRentalViewModel>(context).lastRental ?? Rental.mock;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
            width: screenSize.width,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: [
                Row(
                  children: [
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
                  ],
                ),
                Divider(
                    height: 20,
                    thickness: 0.5,
                    indent: 0,
                    endIndent: 0,
                    color: Theme.of(context).dividerColor),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.total,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      "${(rental.totalPrice!).toStringAsFixed(2)} EUR",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            )));
  }

  Widget get _doneButton {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CupertinoActivityIndicator(radius: 20.0, color: Colors.green),
          AnimatedOpacity(
            opacity: animate ? 1 : 0,
            duration: const Duration(milliseconds: 100),
            child: Lottie.asset(repeat: false, controller: _controller,
                onLoaded: (composition) {
              _controller.duration = composition.duration;
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  animate = true;
                });

                _controller.forward();
              });
            }, width: 100, height: 100, 'assets/animations/checkmark.json'),
          ),
          CupertinoButton(
              color: Colors.transparent,
              child: const Text(""),
              onPressed: () {
                HapticFeedback.selectionClick();
                Provider.of<CompositeViewModel>(context, listen: false)
                    .setSheetState(MapSheetState.vanished);
              }),
        ],
      ),
    );
  }
}
