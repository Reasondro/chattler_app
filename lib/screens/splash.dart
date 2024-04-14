import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chattler"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text(
          "Loading ...",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
