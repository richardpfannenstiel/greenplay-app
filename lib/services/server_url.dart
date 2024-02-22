enum ServerURL {
  stations,
  gadgets,
  startRentGadget,
  stopRentGadget,
  fetchActiveRental
}

extension ServerURLExtension on ServerURL {
  String path({arguments}) {
    switch (this) {
      case ServerURL.stations:
        return 'station';
      case ServerURL.gadgets:
        return 'station/${arguments[0]}/gadget';
      case ServerURL.startRentGadget:
        return 'gadget/${arguments[0]}/rent';
      case ServerURL.stopRentGadget:
        return 'gadget/${arguments[0]}/return';
      case ServerURL.fetchActiveRental:
        return 'rental/active';
      default:
        return '';
    }
  }
}
