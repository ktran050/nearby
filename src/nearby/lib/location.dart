import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haversine/haversine.dart';
import 'package:flutter/services.dart';

enum LocationState{
  enabled,
  disabled
}

Position _currentLocation = null;

Future<Position> updateLocation() async{
  Future<Position> position;

  try {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    position = geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  } on PlatformException {
    position = null;
  }
  _currentLocation = await position;

  return position;
}