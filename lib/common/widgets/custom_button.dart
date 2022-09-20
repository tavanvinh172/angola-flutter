import 'package:flutter/material.dart';
import 'package:flutter_angola/color.dart';

ElevatedButton customButton(
    {required VoidCallback onPressed, required Text text}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
        primary: appBarColor, minimumSize: const Size(double.infinity, 30)),
    child: text,
  );
}
