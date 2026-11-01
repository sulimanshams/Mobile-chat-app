import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget{
  const ChatMessages({super.key});


  @override
  Widget build(BuildContext context) {
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
              itemBuilder: (ctx , index) => Text(
                     loadedMessages[index].data()["text"]
          ));
        }
    );
    

  }
}