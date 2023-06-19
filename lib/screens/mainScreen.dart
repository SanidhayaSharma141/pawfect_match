import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pawfect_match/screens/verifyEmail.dart';

import 'auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            body: Center(
              child: Container(
                // margin: const EdgeInsets.only(
                //   top: 10,
                //   bottom: 20,
                //   left: 20,
                //   right: 20,
                // ),
                width: double.infinity,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          if (!snapshot.data!.isAnonymous || snapshot.data!.emailVerified) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                title: Text('Your Account'),
                actions: [
                  IconButton(
                      onPressed: () async {
                        if (await GoogleSignIn().isSignedIn()) {
                          GoogleSignIn().signOut();
                        }
                        FirebaseAuth.instance.signOut();
                      },
                      icon: const Icon(Icons.exit_to_app_outlined))
                ],
              ),
              body: Container(
                height: 200,
                width: 200,
                child: Center(
                  child: Text(
                    'Logged In!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            );
          } else {
            return VerifyEmail();
          }
        }

        return const AuthScreen();
      },
    );
  }
}
