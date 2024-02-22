import '../gadget/gadget.dart';

class Rental {
  static final Rental mock =
      Rental(id: 1, start: DateTime.now(), gadget: Gadget.mock, active: true);

  final num id;
  DateTime start;
  DateTime? end;
  num? totalPrice;
  final Gadget gadget;
  bool active;

  Rental({
    required this.id,
    required this.start,
    this.end,
    this.totalPrice,
    required this.gadget,
    required this.active,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      id: json['ID'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      totalPrice: json['total'],
      gadget: Gadget.fromJson(json['gadget']),
      active: json['active'],
    );
  }
}
