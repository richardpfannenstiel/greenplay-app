import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/gadget/gadget.dart';
import '../../models/map/map_sheet_state.dart';
import '../../models/rental/rental.dart';
import '../../models/station/station.dart';
import '../../services/communication_service.dart';
import '../../services/server_url.dart';
import '../composite_view_model.dart';
import 'package:flutter/services.dart';

class ActiveRentalViewModel extends ChangeNotifier {
  Rental? _lastRental;
  Rental? get lastRental => _lastRental;

  Station? _returnStation;
  Station? get returnStation => _returnStation;

  Rental? _activeRental;
  Rental? get activeRental => _activeRental;

  Duration elapsed = Duration.zero;
  late Timer timer;

  bool _showingActiveRentalPill = false;
  bool get showingActiveRentalPill => _showingActiveRentalPill;

  bool _showingCloseLockerNotification = false;
  bool get showingCloseLockerNotification => _showingCloseLockerNotification;

  double _activeRentalPillHeight = 60;
  double get activeRentalPillHeight => _activeRentalPillHeight;

  ActiveRentalViewModel() {
    if (Supabase.instance.client.auth.currentSession != null) {
      fetchActiveRental();
    }
  }

  Future<void> fetchActiveRental() async {
    try {
      final response = await CommunicationService.shared
          .post(ServerURL.fetchActiveRental.path());
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        if (body['rental'] == null) {
          // No active rental, no need to restore the state.
          return;
        }

        _activeRental = Rental.fromJson(body['rental']);
        _returnStation = Station.fromJson(body['returnStation']);

        runTimer(startTime: activeRental!.start);
        Future.delayed(const Duration(milliseconds: 1000), () {
          _showingActiveRentalPill = true;
          notifyListeners();
        });
      }
    } catch (e) {
      // Catch non-responding server.
    }
  }

  void setRentalActive() {
    if (activeRental != null) {
      _activeRental!.active = true;
      _activeRental!.start = DateTime.now();
      runTimer(startTime: activeRental!.start);
      Future.delayed(const Duration(milliseconds: 1000), () {
        _showingActiveRentalPill = true;
        Future.delayed(const Duration(milliseconds: 1000), () {
          showCloseLockerNotification();
        });
        notifyListeners();
      });
    }
  }

  void showCloseLockerNotification() {
    _activeRentalPillHeight = 120;
    Future.delayed(const Duration(milliseconds: 600)).then((value) {
      _showingCloseLockerNotification = true;
    });
    Future.delayed(const Duration(seconds: 10)).then((value) {
      _showingCloseLockerNotification = false;
      _activeRentalPillHeight = 60;
    });
  }

  void finishRental(BuildContext context) {
    if (activeRental != null) {
      _activeRental!.active = false;
      _activeRental!.totalPrice = _calculateEstimatedTotal(
          _activeRental!.gadget.price as double, elapsed);
      _activeRental!.end = DateTime.now();

      _lastRental = activeRental;
      _activeRental = null;
      _returnStation = null;

      cancelTimer();
      notifyListeners();

      HapticFeedback.heavyImpact();
      provider.Provider.of<CompositeViewModel>(context, listen: false)
          .setSheetState(MapSheetState.rentalFinished);
    }
  }

  double _calculateEstimatedTotal(double pricePerMinute, Duration rentalTime) {
    var duration = rentalTime.inSeconds / 60;
    if (duration < 1) {
      duration = duration.ceilToDouble();
    }
    return pricePerMinute * duration;
  }

  void runTimer({startTime}) {
    var initialTime = startTime ?? DateTime.now();
    timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      final now = DateTime.now();
      elapsed = now.difference(initialTime);

      if (_showingActiveRentalPill) {
        notifyListeners();
      }
    });
  }

  void cancelTimer() {
    timer.cancel();
    elapsed = Duration.zero;
  }

  Future<bool> startRental(BuildContext context) async {
    final Station station =
        provider.Provider.of<CompositeViewModel>(context, listen: false)
            .selectedStation!;
    final Gadget gadget =
        provider.Provider.of<CompositeViewModel>(context, listen: false)
            .selectedGadget!;
    try {
      final response = await CommunicationService.shared
          .post(ServerURL.startRentGadget.path(arguments: [gadget.id]));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        _activeRental = Rental.fromJson(body);
        _returnStation = station;
        return Future.value(true);
      }
    } catch (e) {
      return Future.value(false);
    }
    return Future.value(false);
  }

  Future<bool> requestStopRental(BuildContext context) async {
    try {
      final response = await CommunicationService.shared.put(
          ServerURL.stopRentGadget.path(arguments: [activeRental!.gadget.id]));
      if (response.statusCode == 200) {
        _showingActiveRentalPill = false;
        notifyListeners();

        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (e) {
      return Future.value(false);
    }
  }
}
