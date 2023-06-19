import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pawfect_match/providers/themeMode.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _form = GlobalKey<FormState>();
  // File? _selectedImage;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _enteredPhoneNumber = '';
  var _isLogin = true;
  var _isAuthenticating = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print('Google sign-in failed: $e');
      return null;
    }
  }

  void _submitAnonymously() async {
    final userCredential = await _firebase.signInAnonymously();
    print(userCredential);
  }

  void _submit() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredential = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(userCredential);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        // final storageRef = FirebaseStorage.instance
        //     .ref()
        //     .child('user_images')
        //     .child('${userCredentials.user!.uid}.jpg');

        // await storageRef.putFile(_selectedImage!);
        // final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'date': DateTime.now(),
          // 'image_url': imageUrl,
          'phone_number': _enteredPhoneNumber,
        });
      }
    } on FirebaseAuthException catch (error) {
      _form.currentState!.reset();
      setState(() {
        _isAuthenticating = false;
      });
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Email Already in use. Try again with valid Email Address')),
        );
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tMode = ref.watch(themeMode);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
                ref.read(themeMode) == ThemeMode.light
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode,
                color: ref.read(themeMode) == ThemeMode.light
                    ? Colors.black
                    : Colors.white),
            onPressed: () =>
                ref.read(themeMode.notifier).themeModeChange(tMode),
          )
        ],
        title: Text('Pawfect Match',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // margin: const EdgeInsets.only(
                //   top: 10,
                //   bottom: 20,
                //   left: 20,
                //   right: 20,
                // ),
                // width: double.infinity,
                // height: 100,
                child: Image.asset('assets/images/pets.png',
                    fit: BoxFit.fill, width: double.infinity),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary)),
                child: Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  margin: const EdgeInsets.all(5),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // if (!_isLogin)
                            //   UserImagePicker(
                            //     pickImage: (pickedImage) {
                            //       _selectedImage = pickedImage;
                            //     },
                            //   ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Email Address'),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail = value!;
                              },
                            ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Username'),
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return 'Please enter at least 4 characters.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredUsername = value!;
                                },
                              ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Phone Number'),
                                keyboardType: TextInputType.phone,
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length != 10) {
                                    return 'Please Enter valid phone number';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPhoneNumber = value!;
                                },
                              ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password must be at least 6 characters long.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!;
                              },
                            ),
                            const SizedBox(height: 12),
                            if (_isAuthenticating)
                              const CircularProgressIndicator(),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Text(_isLogin ? 'Login' : 'Signup'),
                              ),
                            if (!_isAuthenticating)
                              TextButton(
                                onPressed: () {
                                  if (_form.currentState != null) {
                                    _form.currentState!.reset();
                                  }
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? 'Create an account'
                                    : 'I already have an account'),
                              ),
                            if (!_isAuthenticating && _isLogin)
                              ElevatedButton(
                                onPressed: _submitAnonymously,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Text('Sign in anonymously'),
                              ),

                            if (!_isAuthenticating && _isLogin)
                              ElevatedButton(
                                onPressed: () async {
                                  UserCredential? userCredential =
                                      await _signInWithGoogle();
                                  if (userCredential == null) {
                                    // Sign-in with Google failed
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content: Text(
                                              'Failed to sign in with Google.'),
                                          actions: [
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Text('Sign in with Google'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
