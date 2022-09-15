import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_angola/color.dart';
import 'package:flutter_angola/widgets/contacts_list.dart';

class MobileLayoutScreen extends StatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);
  static const String routeName = '/mobile-layout-screen';
  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen> {
  List<Widget> pages = [
    const ContactsList(),
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.red,
    ),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Angola'),
        elevation: 0,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
          backgroundColor: appBarColor,
          items: const [
            TabItem(icon: Icons.message, title: 'Message'),
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.add, title: 'Add'),
            TabItem(icon: Icons.notifications, title: 'Message'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: 2, //optional, default as 0
          onTap: (int i) {
            setState(() {
              _currentIndex = i;
            });
          }),
    );
  }
}
