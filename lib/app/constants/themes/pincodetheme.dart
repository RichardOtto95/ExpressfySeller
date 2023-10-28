import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

final PinTheme customPinTheme = PinTheme(
  shape: PinCodeFieldShape.box,
  borderRadius: BorderRadius.circular(12),
  fieldHeight: 64,
  fieldWidth: 40,
  borderWidth: 1,
  activeFillColor: Colors.white,
  selectedFillColor: primary.withOpacity(.9),
  inactiveFillColor: Colors.white,
  activeColor: Colors.transparent,
  inactiveColor: Colors.transparent,
  selectedColor: primary.withOpacity(.9),
);
