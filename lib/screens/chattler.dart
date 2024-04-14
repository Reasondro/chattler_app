import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class ChattlerScreen extends StatefulWidget {
  const ChattlerScreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _ChattlerState();
  }
}

class _ChattlerState extends State<ChattlerScreen> {
  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      alignment: Alignment.center,
      child: Text(
        "Chat Now!",
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
        textAlign: TextAlign.center,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chattler"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {
              _firebase.signOut();
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Signed out."),
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7))),
              ));
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 211, 67, 57),
            ),
          ),
        ],
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "Talk shit!",
        child: const Icon(Icons.chat_outlined),
      ),
    );
  }
}
