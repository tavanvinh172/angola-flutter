import 'package:flutter/material.dart';
import 'package:flutter_angola/screens/mobile_layout_screen.dart';
import 'package:flutter_angola/screens/web_layout_screen.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout(
      {Key? key,
      required this.mobileLayoutScreen,
      required this.webLayoutScreen})
      : super(key: key);
  final MobileLayoutScreen mobileLayoutScreen;
  final WebLayoutScreen webLayoutScreen;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return LayoutBuilder(builder: (context, constraints) {
      if (size.width > 600) {
        return webLayoutScreen;
      } else {
        return mobileLayoutScreen;
      }
    });
  }
}
