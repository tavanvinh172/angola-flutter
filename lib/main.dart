import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_angola/color.dart';
import 'package:flutter_angola/features/auth/screens/login_screen.dart';
import 'package:flutter_angola/models/user.dart';
import 'package:flutter_angola/router.dart';
import 'package:flutter_angola/screens/mobile_layout_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  String finalEmail = "";
  Future getCurrentUser() async {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey(
      UserModel.userPersistenceKey,
    )) {
      setState(() {
        final data = preferences.getString(UserModel.userPersistenceKey);
        finalEmail = data!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light()
          .copyWith(appBarTheme: const AppBarTheme(color: appBarColor)),
      onGenerateRoute: (settings) => generateRoute(settings),
      home:
          finalEmail.isEmpty ? const LoginScreen() : const MobileLayoutScreen(),
      // const ResponsiveLayout(
      //   mobileLayoutScreen: MobileLayoutScreen(),
      //   webLayoutScreen: WebLayoutScreen(),
      // )
      // const LoginScreen()
      // const ,
    );
  }
}
