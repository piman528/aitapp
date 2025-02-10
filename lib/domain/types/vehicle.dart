import 'package:aitapp/domain/types/destination.dart';
import 'package:aitapp/domain/types/station.dart';
import 'package:aitapp/domain/types/vehicles.dart';
import 'package:flutter/material.dart';

class Vehicle {
  Vehicle({
    required this.vehicle,
    required this.icon,
    required this.destination,
    required this.stations,
  });
  final Vehicles vehicle;
  final IconData icon;
  final Destination destination;
  final List<Station> stations;
}
