import 'package:flutter/animation.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class SheetPosition {
  static const SnappingPosition zero = SnappingPosition.pixels(
    positionPixels: 0,
    snappingCurve: Curves.easeInOut,
    snappingDuration: Duration(milliseconds: 300),
  );

  static const SnappingPosition bottom = SnappingPosition.pixels(
    positionPixels: 210,
    snappingCurve: Curves.easeInOut,
    snappingDuration: Duration(milliseconds: 300),
  );

  static const SnappingPosition half = SnappingPosition.pixels(
    positionPixels: 400,
    snappingCurve: Curves.easeInOut,
    snappingDuration: Duration(milliseconds: 300),
  );

  static const SnappingPosition full = SnappingPosition.factor(
    positionFactor: 0.9,
    snappingCurve: Curves.easeInOut,
    snappingDuration: Duration(milliseconds: 300),
  );
}
