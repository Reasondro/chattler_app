import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>(); //! always need this

  var _isLogin = true;

  String _enteredEmail = "";
  String _enteredPassword = "";

  void _submit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      print(_enteredEmail);
      print(_enteredPassword);
    }
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
              // const SizedBox(
              //   height: 40,
              // ),
              Card(
                color: Theme.of(context).colorScheme.background,
                // borderOnForeground: false,
                margin: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 10, right: 10),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, //? also no effect? gotta test more
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Email Address"),
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
                            decoration:
                                const InputDecoration(labelText: "Password"),
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
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                              _isLogin ? "Sign In" : "Sign Up",
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                                // _isLogin = _isLogin ? false : true;
                              });
                            },
                            child: Text(_isLogin
                                ? "Create an account"
                                : "I already have an account"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
