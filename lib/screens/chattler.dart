import 'package:flutter/material.dart';

class Chattler extends StatefulWidget {
  const Chattler({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ChattlerState();
  }
}

class _ChattlerState extends State<Chattler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chattler"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text(
          "Chat Now!",
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
