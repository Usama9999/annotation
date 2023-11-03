import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'details.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login to continue",
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  try {
                    EasyLoading.show();
                    var googleSign = GoogleSignIn(scopes: ["email"]);
                    final user = await googleSign.signIn();
                    final googleAuth = await user!.authentication;
                    final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken);
                    await FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((value) async {
                      EasyLoading.dismiss();
                      EasyLoading.showToast('Logged in successfully',
                          toastPosition: EasyLoadingToastPosition.bottom);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const MyHomePage(
                                title: 'Select options',
                              )));
                    });
                  } catch (e) {
                    EasyLoading.dismiss();
                    EasyLoading.showToast('Something went wrong! Try again',
                        toastPosition: EasyLoadingToastPosition.bottom);
                  }
                },
                child: Image.asset(
                  'assets/ic_google.png',
                  width: 100,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
