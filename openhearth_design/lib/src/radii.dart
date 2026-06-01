import 'package:flutter/material.dart';

abstract final class OhRadii {
  static const sm   = BorderRadius.all(Radius.circular(4));
  static const md   = BorderRadius.all(Radius.circular(8));
  static const lg   = BorderRadius.all(Radius.circular(12));
  static const xl   = BorderRadius.all(Radius.circular(16));
  static const full = BorderRadius.all(Radius.circular(999)); // pill/stadium
}
