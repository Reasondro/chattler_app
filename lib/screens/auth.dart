import 'package:chattler_app/widgets/user_image_picker.dart';
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
  String _enteredPassword = "";

  void _submit() async {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }
    try {
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
        // print(userCredentials);
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
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
                    top: 25, bottom: 50, left: 20, right: 20),
                child: Image.asset(
                  'assets/images/chat3.png',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Text(
                "P.S. Logo di atas curi dari google, warnanya doang diganti 😂",
                style: TextStyle(fontSize: 10),
              ),
              const SizedBox(
                height: 15,
              ),
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
                        if (!_isSignInMode) const UserImagePicker(),
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
