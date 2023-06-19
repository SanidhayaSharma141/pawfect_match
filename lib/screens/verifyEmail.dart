import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawfect_match/screens/homeScreen.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  var _isVerified = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!_isVerified) {
      try {
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
  }

  @override
  void dispose() {
    print('disposed');
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isVerified
        ? HomeScreen()
        : Scaffold(
            appBar: AppBar(
                // App bar configuration
                ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please verify your email before logging in.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: Text('Sign Out'),
                  ),
                ],
              ),
            ),
          );
  }
}
