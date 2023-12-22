import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_chip/Custom%20Data/Events.dart';
import 'package:project_blue_chip/Firebase/BookingEventsFirebase.dart';
import 'package:project_blue_chip/Firebase/UserFirebase.dart';
import 'package:project_blue_chip/Screens/LogIn/SignInScreen.dart';
import 'package:project_blue_chip/Screens/Schedule/Admin/AdminScheduleScreen.dart';
import 'package:project_blue_chip/Screens/Schedule/ScheduleScreen.dart';

import '../../Custom Data/BlackOutDates.dart';
import '../../Custom Data/Users.dart';
import '../Food Menu/CategoryMenuScreen.dart';
import '../Schedule/OpenSchedule.dart';
import '../Settings/Settings.dart';


class MainMenuScreen extends StatefulWidget {
  final Users users;

  MainMenuScreen({required this.users});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {

  UsersFirebase usersFirebase = UsersFirebase();
  BookingEventsFirebase bookingEventsFirebase = BookingEventsFirebase();



  List<DateTime> blackoutDates = [];

  setUp() async {
    final docRef = FirebaseFirestore.instance
        .collection('blackOutDates').withConverter(
        fromFirestore: BlackOutDates.fromFireStore,
        toFirestore: (BlackOutDates blackOutDates, options) =>
            blackOutDates.toFireStore()).get().then((value) async =>
    {
      value.docs.forEach((element) {
        blackoutDates.add(element
            .data()
            .startTime);
        print("${element
            .data()
            .startTime}");
      }),
      // print("Black out")
    });

    bookingEventsFirebase.getAllEvents();

    //print("Black out length ${blackoutDates.length}");
  }


  @override
  void initState() {
    super.initState();

    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,


        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Text("Select schedule before selecting menu options but feel free to browse the menu beforehand.",style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              IconButton(onPressed: () {
                usersFirebase.signOutUser();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                        (route) => false);
              }, icon: Icon(Icons.logout_outlined)),

              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) => CategoryMenuScreen(users: widget.users,datePicked: false,blackoutDates:
                      blackoutDates,)));
                  },
                      child: const Text(
                          "Food Menu", textAlign: TextAlign.center)),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: () {
                    print("${widget.users.firstName}");

                    widget.users.firstName == 'Guest' ?
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) =>
                        ScheduleScreen(blackoutDates: blackoutDates, users: widget.users, eventName: '', eventLocation: '', amountOfGuest: 1
                        ))):

                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) =>
                        OpenSchedule(
                          users: widget.users, blackoutDates: blackoutDates,)));
                  },
                      child: const Text(
                        "View Schedule", textAlign: TextAlign.center,)),
                ),
              ),

              if(widget.users.admin && widget.users.firstName != "Guest")
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) =>
                          AdminScheduleScreen(blackOutDate: blackoutDates,
                            bookingFirebase: bookingEventsFirebase,)));
                    },
                        child: const Text(
                          "Adjust Schedule", textAlign: TextAlign.center,)),
                  ),
                ),


              if(widget.users.firstName != "Guest")
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) => const mySettings()));
                    },
                        child: const Text(
                          "Settings", textAlign: TextAlign.center,)),
                  ),
                )

            ],
          ),
        ),
      ),
    );
  }
}
