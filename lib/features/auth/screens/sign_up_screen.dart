import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_angola/common/utils/utils.dart';
import 'package:flutter_angola/common/widgets/custom_button.dart';
import 'package:flutter_angola/features/auth/controllers/auth_controller.dart';
import 'package:flutter_angola/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String routeName = '/sign-up-screen';
  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailController = TextEditingController();
  final passwController = TextEditingController();
  File? image;
  void signUpUser() async {
    String email = emailController.text.trim();
    String password = passwController.text.trim();
    if (email.isNotEmpty || password.isNotEmpty) {
      ref.read(authControllerProvider).signUpWithEmailAndPassword(
            context,
            email,
            password,
            image,
          );
      saveCurrentUser(email);
    }
  }

  void saveCurrentUser(String email) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(
      UserModel.userPersistenceKey,
      emailController.text,
    );
  }

  void showDialogPickerImage(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Take a picture',
                      textAlign: TextAlign.center,
                    )),
                onTap: () async {
                  image = await pickImageFromCamera(context);
                  setState(() {});
                },
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Choose from gallery',
                      textAlign: TextAlign.center,
                    )),
                onTap: () async {
                  image = await pickImageFromGallery(context);
                  setState(() {});
                },
              ),
              InkWell(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                    )),
                onTap: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Stack(
                  children: [
                    image == null
                        ? const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1599137937039-f48e7c6ac0ec?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60'),
                            radius: 64,
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(image!),
                            radius: 64,
                          ),
                    Positioned(
                        bottom: -10,
                        right: 0,
                        child: IconButton(
                            onPressed: () => showDialogPickerImage(context),
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 35,
                            ))),
                  ],
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
                customButton(
                    onPressed: signUpUser, text: const Text('Sign up')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
