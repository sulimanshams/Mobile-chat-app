import 'package:flutter/cupertino.dart';

class ChatMessages extends StatelessWidget{
  const ChatMessages({super.key});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFilestore.instance.collextion("chat").snapshots(),
        builder: builder
    );
    
    return Center(
      child: Text("No messages found ."),
    );
  }
}