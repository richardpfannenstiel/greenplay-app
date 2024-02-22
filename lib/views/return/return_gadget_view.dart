import 'package:flutter/cupertino.dart';
import 'package:greenplay/viewmodels/return/return_gadget_view_model.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/rental/rental.dart';
import '../../viewmodels/rental/active_rental_view_model.dart';
import '../components/circular_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReturnGadgetView extends StatefulWidget {
  const ReturnGadgetView({super.key});

  @override
  State<ReturnGadgetView> createState() => _ReturnGadgetViewState();
}

class _ReturnGadgetViewState extends State<ReturnGadgetView>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    Provider.of<ReturnGadgetViewModel>(context, listen: false)
        .observeLocker(_controller, context);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _stationDescription,
                  const Spacer(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Text(
                  AppLocalizations.of(context)!.summary,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 16),
                ),
              ),
              _rentalSummary,
              Divider(
                  height: 50,
                  thickness: 0.5,
                  indent: 0,
                  endIndent: 0,
                  color: Theme.of(context).dividerColor),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(repeat: false, controller: _controller,
                      onLoaded: (composition) {
                    _controller.duration = composition.duration;
                  }, 'assets/animations/box.json'),
                  Text(
                    Provider.of<ReturnGadgetViewModel>(context).lockerIsOpen
                        ? AppLocalizations.of(context)!.returnGadgetInfo
                        : AppLocalizations.of(context)!.lockOpens,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
                    child: CupertinoActivityIndicator(
                        radius: 20.0, color: Colors.green),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ));
  }

  Widget get _rentalSummary {
    final screenSize = MediaQuery.of(context).size;
    Rental rental = Provider.of<ActiveRentalViewModel>(context, listen: false)
            .activeRental ??
        Rental.mock;
    final elapsedTime =
        Provider.of<ActiveRentalViewModel>(context, listen: false).elapsed;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
            width: screenSize.width,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: [
                CircularImage(
                    imageString:
                        'assets/gadgets/${rental.gadget.type.toLowerCase()}.png',
                    size: 20,
                    backgroundColor: Colors.green),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(
                            rental.gadget.type,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 18),
                          ),
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.rentedFor} ${(elapsedTime.inSeconds / 60).ceil()} ${AppLocalizations.of(context)!.minutes}",
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.estimatedTotal} ${(Provider.of<ReturnGadgetViewModel>(context, listen: false).calculateEstimatedTotal(rental.gadget.price as double, elapsedTime)).toStringAsFixed(2)} EUR",
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    )),
                const Spacer(),
              ],
            )));
  }

  Widget get _stationDescription {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.returnGadget,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ],
    );
  }
}
