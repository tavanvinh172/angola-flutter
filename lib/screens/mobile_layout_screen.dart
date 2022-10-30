import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_angola/color.dart';
import 'package:flutter_angola/features/chat/widgets/contacts_list.dart';
import 'package:flutter_angola/features/feed/screens/feed_screen.dart';
import 'package:flutter_angola/features/notification/screens/notification_screen.dart';
import 'package:flutter_angola/features/post/screens/upload_post_screen.dart';
import 'package:flutter_angola/features/profile/screens/profile_screen.dart';

class MobileLayoutScreen extends StatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);
  static const String routeName = '/mobile-layout-screen';
  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen> {
  bool isProfile = false;
  bool isNotification = false;
  bool isFeedScreen = false;
  int _currentIndex = 0;
  List<Widget> pages = [
    const ContactsList(),
    const FeedScreen(),
    const UploadPostScreen(),
    const NotificationScreen(),
    ProfileScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: !isProfile && !isNotification && !isFeedScreen
          ? AppBar(
              title: const Text('Angola'),
              elevation: 0,
            )
          : null,
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
              if (_currentIndex == 4) {
                isProfile = true;
              } else if (_currentIndex == 3) {
                isNotification = true;
              } else if (_currentIndex == 1) {
                isFeedScreen = true;
              } else {
                isProfile = false;
                isNotification = false;
                isFeedScreen = false;
              }
            });
          }),
    );
  }
}
