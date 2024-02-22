import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({super.key, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      height: 35,
      child: RawMaterialButton(
        //constraints: BoxConstraints.tight(const Size(32, 32)),
        fillColor: Theme.of(context).cardColor,
        elevation: 0.0,
        shape: const CircleBorder(),
        onPressed: () => callback(),
        //elevation: 0.0,
        child: Icon(Icons.arrow_back,
            color: Theme.of(context).hintColor, size: 24.0),
      ),
    );
  }
}
