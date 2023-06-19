import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _firebase = FirebaseAuth.instance;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: Text('Your Account'),
        actions: [
          IconButton(
              onPressed: () async {
                if (await GoogleSignIn().isSignedIn()) {
                  GoogleSignIn().signOut();
                }
                _firebase.signOut();
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
  }
}
