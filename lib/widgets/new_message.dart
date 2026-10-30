import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget{
  const NewMessage({super.key});


  @override
  State<StatefulWidget> createState() {
        return _NewMessageState();
  }

}


class _NewMessageState extends State<NewMessage>{


  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _subimtMessage() async{
    final enteredMessage = _messageController.text;

    if(enteredMessage.trim().isEmpty){
      return;
    }
    FocusScope.of(context).unfocus();

 final user =FirebaseAuth.instance.currentUser!;
   final userData = await FirebaseFilestore.instance.collection("users").doc(user.uid).get();

    FirebaseFilestore.instance.collection("chat").add({
      "text" : enteredMessage,
      "createdAt" : Timestamp.now(),
      "userId" : user.uid,
      "username" : userData.data()!["username"],
      "userImage" : userData.data()!["image_url"]
    });


    _messageController.clear();
  }


  @override
  Widget build(BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(left: 15 , right: 1 , bottom: 14),
          child: Row(
             children: [
               Expanded(
                 child: TextField(
                   textCapitalization: TextCapitalization.sentences,
                   autocorrect: true,
                   enableSuggestions: true,
                   decoration: InputDecoration(
                     labelText: "send a message ...."
                   ),
                 ),
               ),
               IconButton(
                 color: Theme.of(context).colorScheme.primary,
                 icon: Icon(Icons.send),
                 onPressed: () {

                 },
               ),
             ],
          ),
        );
  }

}