import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get returnGadget => 'Return';

  @override
  String get cancel => 'Cancel';

  @override
  String get searchFor => 'Search for stations, gadgets, ...';

  @override
  String get lockerStation => 'Greenplay Rental Station';

  @override
  String get available => 'Available';

  @override
  String get distance => 'Distance';

  @override
  String get availableGadgets => 'Available Gadgets';

  @override
  String get reportProblem => 'Report a Problem';

  @override
  String get saveFavorite => 'Save as Favorite';

  @override
  String get loadingAvailableGadgets => 'Loading available Gadgets';

  @override
  String get perMinute => 'per minute';

  @override
  String get costs => 'Costs';

  @override
  String get summary => 'Summary';

  @override
  String get startRental => 'Start Rental';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get error => 'Error';

  @override
  String get startRentalError => 'The gadget you selected could not be rented.';

  @override
  String get thankYou => 'Thank You!';

  @override
  String get minutes => 'minutes';

  @override
  String get estimatedTotal => 'Esitamted Total';

  @override
  String get rentedFor => 'Rented for';

  @override
  String get activeRentalInProgress => 'Active Rental in Progress';

  @override
  String get returnGadgetInfo => 'Please put the gadget into the open locker compartment and close it.';

  @override
  String get returnWarningHeader => 'Are you sure?';

  @override
  String get returnWarningInfo => 'The locker will be opened for you to return the gadget.';

  @override
  String get showDirections => 'Show directions';

  @override
  String get rentedOut => 'Rented out';
}
