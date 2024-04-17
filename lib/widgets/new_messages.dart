import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  var messageController = TextEditingController();

  @override
  void dispose() //! a must for TextField stuffs
  {
    messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final String enteredMessage = messageController.text;

    if (enteredMessage.trim().isEmpty) {
      //TODO send an error message
      return;
    }
    FocusScope.of(context).unfocus(); //? cloase any open keyboard
    messageController.clear(); //? reset the text field

    final user = FirebaseAuth.instance.currentUser!; //?
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    await FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              textCapitalization: TextCapitalization.sentences,
              // autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: "Send a message..."),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              _submitMessage();
            },
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
