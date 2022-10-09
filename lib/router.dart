import 'package:flutter/material.dart';
import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/features/auth/screens/login_screen.dart';
import 'package:flutter_angola/features/auth/screens/sign_up_screen.dart';
import 'package:flutter_angola/features/post/widgets/comment_screen.dart';
import 'package:flutter_angola/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter_angola/screens/mobile_layout_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const MobileLayoutScreen());
    case SignUpScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SignUpScreen());
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final email = arguments['email'];
      final uid = arguments['uid'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                email: email,
                profilePic: profilePic,
                uid: uid,
              ));
    case CommentScreen.routeName:
      final postId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => CommentScreen(
                postID: postId,
              ));
    default:
      return MaterialPageRoute(
          builder: (context) => const ErrorScreen(
                error: 'There\'s no page exists',
              ));
  }
}
