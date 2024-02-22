import 'package:flutter/material.dart';

enum StationStatus { available, unavailable, empty }

extension StationStatusExtension on StationStatus {
  String get name {
    switch (this) {
      case StationStatus.available:
        return 'Available';
      case StationStatus.unavailable:
        return 'Unavailable';
      case StationStatus.empty:
        return 'Empty';
    }
  }

  Color get color {
    switch (this) {
      case StationStatus.available:
        return Colors.green;
      case StationStatus.unavailable:
        return Colors.red;
      case StationStatus.empty:
        return Colors.orange;
    }
  }

  static StationStatus fromString(String status) {
    switch (status) {
      case "Available":
        return StationStatus.available;
      case "Empty":
        return StationStatus.empty;
      default:
        return StationStatus.unavailable;
    }
  }
}
