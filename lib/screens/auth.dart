import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}


class _AuthScreenState extends State<AuthScreen> {

  final _formKey = GlobalKey<FormState>();

  var _islogin = true;
  var _enteredEmail = "";
  var _enteredPassword = "";


  void _submit () async {
   final isValid = _formKey.currentState!.validate();
   
   if(!isValid){
     return;
   }

   _formKey.currentState!.save();


   if(_islogin) {
   //   log in user
   }else{
     try{
        final userCredentails = await  _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail,
            password: _enteredPassword
        );
     } on FirebaseAuthException catch (error){
        if(error.code == "email-already-in-use"){
        //   ....
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? "Authentication failed")));
     }

   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset("assets/images/chat.png")
              ),
              Card(
                margin: EdgeInsets.all(20),
                child:  Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email Address"
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false ,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if(value == null || value.trim().isEmpty || !value.contains("@")){
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                          onSaved: (value) {
                              _enteredEmail = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Password"
                          ),
                          obscureText: true,
                          validator: (value) {
                            if(value == null || value.trim().length < 6 ){
                              return "Please must be at least 6 characters long . ";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        const SizedBox(height: 12,),
                        ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer
                            ),
                            child: Text(_islogin? "Login" :"Signup")
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _islogin = _islogin ? false : true;
                              });
                            },
                            child: Text(_islogin ? "Create an account" : "I already have an account"),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}