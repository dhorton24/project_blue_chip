import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_chip/Custom%20Data/PageView.dart';
import 'package:project_blue_chip/Screens/LogIn/SignInScreen.dart';
import 'package:project_blue_chip/Screens/LogIn/SlidesScreen.dart';
import 'package:project_blue_chip/Screens/Main%20Menu/MainMenuScreen.dart';
import 'package:project_blue_chip/Screens/Main%20Menu/NavigationScreen.dart';

import '../../Custom Data/Users.dart';
import '../../Firebase/UserFirebase.dart';
import 'package:is_first_run/is_first_run.dart';




class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {

  UsersFirebase usersFirebase = UsersFirebase();


  decideState()async{

    Users? users;

    bool firstRun = await IsFirstRun.isFirstCall();

    print("Is first run: ${firstRun}");

    if(FirebaseAuth.instance.currentUser  != null) {
      // usersFirebase.signOutUser();
      users = await usersFirebase.getUser();


    }


    if(FirebaseAuth.instance.currentUser == null){

      //if this is the first install, show slideshow intro. If not, proceed to
      if(firstRun)

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SlidesScreen()), (route) => false);

      else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInScreen()));
      }


    }else{


      Navigator.push(context, MaterialPageRoute(builder: (context)  =>NavigationScreen(users: users!)));
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

  FirstTimeItems firstTimeItems = FirstTimeItems();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(

            height: 200,
            width: 200,
            child: Hero(
                tag: 'Hero',
                child: Image.asset('lib/Images/Nacho Momma Abbreviated Banner.JPG')),
          ),
        ),
      ),
    );
  }
}
