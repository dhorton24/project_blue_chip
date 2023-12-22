import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_chip/Screens/LogIn/SignInScreen.dart';
import 'package:project_blue_chip/Screens/Main%20Menu/MainMenuScreen.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../Custom Data/Users.dart';
import '../../Firebase/UserFirebase.dart';




class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {

  UsersFirebase usersFirebase = UsersFirebase();


  decideState()async{

    Users? users;
    if(FirebaseAuth.instance.currentUser  != null) {
      // usersFirebase.signOutUser();
      users = await usersFirebase.getUser();


    }


    if(FirebaseAuth.instance.currentUser == null){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
    }else{


      Navigator.push(context, MaterialPageRoute(builder: (context)  =>MainMenuScreen(users: users!)));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Signed in as ${users!.email}")));

    }

  }

  @override
  void initState(){
    super.initState();

    Future.delayed(const Duration(seconds: 3),(){
      decideState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Text("Logo Here",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
