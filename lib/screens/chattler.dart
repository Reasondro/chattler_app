import 'package:chattler_app/widgets/chat_messages.dart';
import 'package:chattler_app/widgets/new_messages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  void setUpPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

    final token = await fcm.getToken();
    print(
        "Token: $token"); //* could sen this token (via http or the firestore sdk) to a backedn
  }

  @override
  void initState() //! dont put async in initState
  {
    super.initState();
    setUpPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    //TODO use content implementation (dynamic if no chats or not)
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
      body: const Column(
        children: [
          Expanded //? expanded here to make sure take all the space
              (
            child: ChatMessages(),
          ),
          NewMessage(),
        ],
      ),
      //TODO implement below
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: "Talk shit!",
      //   child: const Icon(Icons.chat_outlined),
      // ),
    );
  }
}
