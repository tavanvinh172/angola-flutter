import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_angola/color.dart';
import 'package:flutter_angola/common/screens/error.dart';
import 'package:flutter_angola/common/screens/loader.dart';
import 'package:flutter_angola/features/auth/controllers/auth_controller.dart';
import 'package:flutter_angola/features/auth/screens/login_screen.dart';
import 'package:flutter_angola/router.dart';
import 'package:flutter_angola/screens/mobile_layout_screen.dart';
import 'package:flutter_angola/screens/web_layout_screen.dart';
import 'package:flutter_angola/utils/responsive_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light()
          .copyWith(appBarTheme: const AppBarTheme(color: appBarColor)),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LoginScreen();
              } else {
                return const ResponsiveLayout(
                    mobileLayoutScreen: MobileLayoutScreen(),
                    webLayoutScreen: WebLayoutScreen());
              }
            },
            error: (error, constraints) {
              return ErrorScreen(error: error.toString());
            },
            loading: () => const Center(
              child: Loader(),
            ),
          ),
      // const ResponsiveLayout(
      //   mobileLayoutScreen: MobileLayoutScreen(),
      //   webLayoutScreen: WebLayoutScreen(),
      // )
      // const LoginScreen()
      // const ,
    );
  }
}
