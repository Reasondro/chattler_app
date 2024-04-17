import 'package:chattler_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenthicatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!(chatSnapshot.hasData) || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No messages found."),
          );
        }

        if (chatSnapshot.hasError) {
          return const Center(
            child: Text("Something went wrong..."),
          );
        }
        final loadedMessages = chatSnapshot.data!.docs;
        return ListView.builder(
          padding:
              const EdgeInsets.only(left: 15, right: 13, top: 13, bottom: 40),
          reverse: true, //? combined with descending
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();

            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;

            // final  Map<String, dynamic>? nextChatMessage;
            // if ((index + 1) < loadedMessages.length) {
            //   nextChatMessage = loadedMessages[index+1].data();
            // } else {
            //   null;
            // }
            final currentMessageUserId =
                chatMessage['userId']; //! dont SPECIFY TYPE
            final nextMessageUserId = nextChatMessage != null
                ? nextChatMessage['userId']
                : null; //! dont SPECIFY TYPE
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                  message: chatMessage['text'],
                  isMe: authenthicatedUser.uid == currentMessageUserId);
            } else {
              return MessageBubble.first(
                  userImage: chatMessage['userImage'],
                  username: chatMessage['username'],
                  message: chatMessage['text'],
                  isMe: authenthicatedUser.uid == currentMessageUserId);
            }
          },
        );
      },
    );
  }
}
