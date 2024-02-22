class Gadget {
  static const Gadget mock =
      Gadget(id: 1, type: "Volleyball", price: 0.08, lockerID: 1, available: true);

  final int id;
  final String type;
  final num price;
  final num lockerID;
  final bool available;

  const Gadget(
      {required this.id,
      required this.type,
      required this.price,
      required this.lockerID,
      required this.available});

  factory Gadget.fromJson(Map<String, dynamic> json) {
    return Gadget(
      id: json['ID'],
      type: json['type'],
      price: json['price'],
      lockerID: json["lockerId"],
      available: json["available"],
    );
  }
}
