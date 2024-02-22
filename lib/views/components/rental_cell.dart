import 'package:flutter/material.dart';
import 'circular_button.dart';

class RentalCell extends StatelessWidget {
  const RentalCell(
      {super.key,
      required this.lockerName,
      required this.item,
      required this.backAction});

  final String lockerName;
  final String item;
  final VoidCallback backAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        children: [
          CircularButton(callback: backAction),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                item,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [const Icon(Icons.place), Text(lockerName)],
              )
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Image(
              image: AssetImage('assets/gadgets/${item.toLowerCase()}.png'),
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
