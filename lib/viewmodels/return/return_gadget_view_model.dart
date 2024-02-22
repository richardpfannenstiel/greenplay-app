import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/mqtt_service.dart';
import '../../viewmodels/rental/active_rental_view_model.dart';

class ReturnGadgetViewModel extends ChangeNotifier {
  bool lockerIsOpen = false;

  final MQTTService mqttService = MQTTService();

  void observeLocker(AnimationController controller, BuildContext context) {
    final stationID = Provider.of<ActiveRentalViewModel>(context, listen: false)
        .returnStation
        ?.id;
    final lockerID = Provider.of<ActiveRentalViewModel>(context, listen: false)
        .activeRental
        ?.gadget
        .lockerID;
    mqttService.connect().then((value) => mqttService
            .subscribe('station/$stationID/lock/$lockerID/state', (content) {
          if (content == 'OPEN') {
            lockerOpened(controller);
          }
          if (content == 'CLOSED') {
            lockerClosed(controller, context);
          }
        }));
  }

  double calculateEstimatedTotal(double pricePerMinute, Duration rentalTime) {
    var duration = rentalTime.inSeconds / 60;
    if (duration < 1) {
      duration = duration.ceilToDouble();
    }
    return pricePerMinute * duration;
  }

  void lockerOpened(AnimationController controller) {
    lockerIsOpen = true;
    notifyListeners();
    // animateTo specifies the percentage of total frames until which the animation shall be played.
    controller.animateTo(0.5);
  }

  void lockerClosed(AnimationController controller, BuildContext context) {
    controller.animateTo(1);
    Future.delayed(const Duration(seconds: 2), () {
      Provider.of<ActiveRentalViewModel>(context, listen: false)
          .finishRental(context);
    });
  }
}
