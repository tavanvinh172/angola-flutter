import 'package:flutter/material.dart';
import 'package:flutter_angola/common/widgets/custom_button.dart';
import 'package:flutter_angola/features/auth/controllers/auth_controller.dart';
import 'package:flutter_angola/features/auth/screens/sign_up_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/login-screen';
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwController.dispose();
  }

  void signInUser() async {
    String email = emailController.text.trim();
    String password = passwController.text.trim();
    if (email.isNotEmpty || password.isNotEmpty) {
      ref.read(authControllerProvider).signInWithEmailAndPassword(
            context,
            email,
            password,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Sign in',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              customButton(onPressed: signInUser, text: const Text('Login')),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don\'t have account? ',
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, SignUpScreen.routeName),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Text(
                    'Other sign in methods',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.phone))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
