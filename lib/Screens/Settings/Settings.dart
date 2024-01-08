import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_blue_chip/Custom%20Data/ConstantDatabase.dart';
import 'package:project_blue_chip/Firebase/UserFirebase.dart';
import 'package:project_blue_chip/Screens/Settings/EditAccountScreen.dart';
import 'package:project_blue_chip/Screens/Settings/MyEventsScreen.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../Custom Data/Users.dart';
import '../../Widgets/TextButtons.dart';
import '../LogIn/SignInScreen.dart';




class mySettings extends StatefulWidget {

  Users users;

  mySettings({super.key, required this.users});

  @override
  State<mySettings> createState() => _mySettingsState();
}

class _mySettingsState extends State<mySettings> {


  bool notifications = true;
  bool toggle = true;

  UsersFirebase usersFirebase = UsersFirebase();

  @override
  void initState() {
    super.initState();

    //setUp();

    toggle= widget.users.notificationsOn;

    // DocumentReference totalReference =
    // FirebaseFirestore.instance.collection('users').doc(widget.users.id);
    //
    // totalReference.snapshots().listen((event) {
    //   if(mounted) {
    //     setState(() {
    //       widget.users.notificationsOn = event.get('notificationsOn');
    //       toggle = widget.users.notificationsOn;
    //     });
    //   }
    // });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                usersFirebase.signOutUser();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SignInScreen()), (route) => false);
              },
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ))
        ],
      ),

      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 6,
                          blurRadius: 5)
                    ]),
                // height: MediaQuery.of(context).size.height * .35,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Image.asset('lib/Images/IMG_8528.JPG'),
                ),
              ).animate().slide(duration: 1500.milliseconds),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text("${widget.users.firstName} ${widget.users.lastName}",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary),),
          ),


          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Powered by',style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: 16),),
                  Container(
                      height: 50,
                      width:100,
                      child: Image.asset('lib/Images/CITex_noBack.png',fit: BoxFit.fitWidth,))
                ],
              ),
              Text("Version: ${ConstantDatabase().version}")
            ],
          ),


          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active_outlined,color: Theme.of(context).colorScheme.primary,),
                    Text("Notifications",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary,fontSize: 18),),
                  ],
                ).animate().fadeIn(),

                Switch(
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: toggle,
                    onChanged: (value) async {

                      setState(() {
                        widget.users.notificationsOn = value;
                        toggle = value;
                      });

                      //TODO change notification in firebase here
                      await usersFirebase.toggleNotification(widget.users);
                    }).animate().fadeIn()
              ],
            ),
          ),

           TextButtons(iconData: Icons.person_2_outlined,text: 'Account',function: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>EditAccountScreen(users: widget.users,)));
           },).animate().fadeIn(),
           TextButtons(iconData: Icons.event_available_outlined,text: 'My Events',function: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>MyEventsScreen(users: widget.users,)));

           }).animate().fadeIn(),
           TextButtons(iconData: Icons.privacy_tip_outlined,text: 'Privacy',function: (){
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No privacy policy made yet")));
           }).animate().fadeIn(),


        ],
      ),
    );
  }
}


