import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final mobilenumberController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  dynamic loginMobileNumber(String mobileNumber) async {
    _auth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      verificationCompleted: (AuthCredential authCredential) {
        print(authCredential.accessToken);
      },
      verificationFailed: (FirebaseAuthException exception) {},
      codeSent: (verificationId, token) {
        print(verificationId);
        print(token);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        print(verificationId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task2"),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: mobilenumberController,
              keyboardType: TextInputType.number,
              onSubmitted: (data) {
                loginMobileNumber(data);
              },
            ),
            RaisedButton(
              child: Text("Login with OTP"),
              onPressed: () {
                loginMobileNumber(mobilenumberController.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
