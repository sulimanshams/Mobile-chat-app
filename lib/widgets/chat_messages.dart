import 'package:chatapp/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget{
  const ChatMessages({super.key});


  @override
  Widget build(BuildContext context) {

    final userAuthenticatedUser = FirebaseAuth.instance.currentUser!;


    return StreamBuilder(
        stream: FirebaseFilestore.instance.collextion("chat").snapshots(),
        builder: (ctx , chatSnapshots) {
          if(chatSnapshots.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
          }

          if(!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty){
            return Center(
              child: Text("No messages found ."),
            );
          }
            final loadedMessages = chatSnapshots.data!.decs;

          return ListView.builder(
            padding: EdgeInsets.only(
              bottom: 40,
              right: 13,
              left: 13,
            ),
              reverse: true,
              itemCount: loadedMessages.length,
              itemBuilder: (ctx , index) {
              final chatMessage = loadedMessages[index].data();
              final nextChatMessage = index+1 < loadedMessages.length ? loadedMessages[index+1].data() : null;

              final currentMessageUserId = chatMessage["userId"];
              final nextMessageUserId = nextChatMessage != null ? nextChatMessage["userId"] : null;

              final nextUserIsSame = nextMessageUserId == currentMessageUserId;

              if(nextUserIsSame) {
                return MessageBubble.next(message: chatMessage["text"], isMe: userAuthenticatedUser.uid == currentMessageUserId);
              }else {
                return MessageBubble.first(
                    userImage: chatMessage["userImage"],
                    username: chatMessage["username"],
                    message: chatMessage["text"],
                    isMe: userAuthenticatedUser.uid == currentMessageUserId,
                );
              }
              }
          );
        }
    );
    

  }
}