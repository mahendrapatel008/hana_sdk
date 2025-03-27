import 'package:flutter/material.dart';

class LocationFetcherNotifier extends ValueNotifier<bool> {
  LocationFetcherNotifier(super.value);
}

final locationFetcherNotifier = LocationFetcherNotifier(false);
