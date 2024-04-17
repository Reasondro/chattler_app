import 'dart:io';

import 'package:chattler_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>(); //! always need this
  bool _isSignInMode = false;

  String _enteredEmail = "";
  String _enteredUsername = "";
  String _enteredPassword = "";

  File? _selectedImage;
  bool _isAuthenticating = false;

  void _submit() async {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }
    if (!_isSignInMode && _selectedImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars(); //? ⬇️ show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("You must select an image"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          // duration: Durations.long3,
          dismissDirection: DismissDirection.down,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
        ),
      );
      return;
    }

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isSignInMode) {
        final UserCredential userCredentials =
            await _firebase.signInWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);
        // print(userCredentials);
      } else {
        final UserCredential userCredentials =
            await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        //? image and user can't be null at this point
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(
                '${userCredentials.user!.uid}.jpg'); //? get the storage path in the firebase storage

        await storageRef
            .putFile(_selectedImage!); //? put the user image in the database
        final imageUrl =
            await storageRef.getDownloadURL(); //? get the image download url

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) //? if the async gap f***d up the built context
      {
        return;
      }

      //! remember, mounted for stateful widget! other class should be state.mounted (must check it though)

      ScaffoldMessenger.of(context).clearSnackBars(); //? ⬇️ show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authenthication failed."),
          backgroundColor: Theme.of(context).colorScheme.primary,
          // duration: Durations.long3,
          dismissDirection: DismissDirection.down,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7)),
          ),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }

    _formKey.currentState!.save(); //? save if out from the try catch
    // print(_enteredEmail);
    // print(_enteredPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        heightFactor: 1.7,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, //? no effect? gotta test more
            children: [
              Text(
                "Chattler",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 40,
                    color: Theme.of(context).colorScheme.onBackground),
                textAlign: TextAlign.right,
              ),
              Container(
                width: 270,
                margin: const EdgeInsets.only(
                    top: 25, bottom: 40, left: 20, right: 20),
                child: Image.asset(
                  'assets/images/chat3.png',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              // const Text(
              //   "P.S. Logo di atas curi dari google, warnanya doang diganti 😂",
              //   style: TextStyle(fontSize: 10),
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, //? also no effect? gotta test more
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!_isSignInMode)
                          UserImagePicker(
                            onPickImage: (pickedImage) {
                              _selectedImage = pickedImage;
                            },
                          ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Email Address"),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        if (!_isSignInMode)
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Create your username"),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 4) {
                                return "Please enter at least 4 characters";
                              }
                              return null;
                            },
                            enableSuggestions: false,
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                          ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: _isSignInMode
                                  ? "Password"
                                  : "Create your password"),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return "Password must be at least 6 characters long";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (_isAuthenticating)
                          const CircularProgressIndicator(),
                        if (!_isAuthenticating)
                          ElevatedButton(
                            onPressed: () {
                              _submit();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            child: Text(
                              _isSignInMode ? "Sign In" : "Sign Up",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                            ),
                          ),
                        if (!_isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isSignInMode = !_isSignInMode;
                                // _isSignInMode = _isSignInMode ? false : true;
                              });
                            },
                            child: Text(_isSignInMode
                                ? "Create an account"
                                : "I already have an account"),
                          )
                      ],
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
