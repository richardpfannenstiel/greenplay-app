import 'app_localizations.dart';

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get helloWorld => 'Hallo Welt!';

  @override
  String get returnGadget => 'Zurückgeben';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get searchFor => 'Suche nach Stationen, Spielen, ...';

  @override
  String get lockerStation => 'Greenplay Ausleihstation';

  @override
  String get available => 'Verfügbar';

  @override
  String get distance => 'Distanz';

  @override
  String get availableGadgets => 'Verfügbare Spiele';

  @override
  String get reportProblem => 'Ein Problem melden';

  @override
  String get saveFavorite => 'Als Favoriten speichern';

  @override
  String get loadingAvailableGadgets => 'Lade verfügbare Spiele';

  @override
  String get perMinute => 'pro Minute';

  @override
  String get costs => 'Kosten';

  @override
  String get summary => 'Zusammenfassung';

  @override
  String get startRental => 'Ausleihen';

  @override
  String get dismiss => 'OK';

  @override
  String get error => 'Fehler';

  @override
  String get startRentalError => 'Das ausgewählte Spiel konnte nicht ausgeliehen werden.';

  @override
  String get thankYou => 'Danke!';

  @override
  String get minutes => 'Minuten';

  @override
  String get estimatedTotal => 'Geschätzter Preis';

  @override
  String get rentedFor => 'Ausgeliehen für';

  @override
  String get activeRentalInProgress => 'Aktive Vermietung läuft';

  @override
  String get returnGadgetInfo => 'Bitte gib das Spiel in das offene Schließfach zurück und schließe die Tür.';

  @override
  String get returnWarningHeader => 'Bist du sicher?';

  @override
  String get returnWarningInfo => 'Das Schließfach wird geöffnet um das Spiel zurückzugeben.';

  @override
  String get showDirections => 'Navigation starten';

  @override
  String get rentedOut => 'Verliehen';
}
