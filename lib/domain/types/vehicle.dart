import 'package:aitapp/domain/types/destination.dart';
import 'package:aitapp/domain/types/station.dart';
import 'package:flutter/material.dart';

class Vehicle {
  Vehicle({
    required this.name,
    required this.displayName,
    required this.icon,
    required this.destination,
    required this.stations,
  });
  final String name;
  final String displayName;
  final IconData icon;
  final Destination destination;
  final List<Station> stations;
}
