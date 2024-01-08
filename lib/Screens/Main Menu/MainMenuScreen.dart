import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:project_blue_chip/Firebase/BookingEventsFirebase.dart';
import 'package:project_blue_chip/Firebase/UserFirebase.dart';
import 'package:project_blue_chip/Screens/LogIn/SignInScreen.dart';

import 'package:spring/spring.dart';

import '../../Custom Data/BlackOutDates.dart';
import '../../Custom Data/TestData.dart';
import '../../Custom Data/Users.dart';
import '../../Firebase/Push Notifications/pushNotification.dart';

class MainMenuScreen extends StatefulWidget {
  final Users users;

  const MainMenuScreen({super.key, required this.users});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  UsersFirebase usersFirebase = UsersFirebase();
  TestData testData = TestData();


  String greeting(){
    var hour = DateTime.now().hour;
    if(hour<12){
      return 'Good Morning';
    }
    if(hour<17){
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  String greetingPic(){
    var hour = DateTime.now().hour;
    if(hour<12){
      return 'lib/Images/MainScreen/sun-161923_1920.png';
    }
    if(hour<17){
      return 'lib/Images/MainScreen/cloud-159393_1920.png';
    }
    return 'lib/Images/MainScreen/full-moon-308007_1920.png';
  }

  @override
  void initState() {
    super.initState();

    //assign token if user is not a guest
    if (widget.users.firstName != 'Guest') {
      PushNotifications().assignTokenToUser(widget.users);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            actions: [

            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // topContainer(context),

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
                    ),
                  ],
                ).animate().slide(duration: 1500.milliseconds),

                weatherContainer(context),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Explore catering options using the bottom navigation tool.",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )),
    );
  }

  Padding weatherContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 8, left: 16, right: 16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).colorScheme.secondary,
            boxShadow: const [
              BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 2)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          greeting(),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 22),
                        ).animate().slideX(
                            duration: 2000.milliseconds,
                            curve: Curves.easeInCirc),
                      ],
                    ),
                  ).animate().fadeIn(duration: 2000.milliseconds),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Date",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                      ),
                    ],
                  ).animate().fadeIn(duration: 2000.milliseconds),
                  Row(
                    children: [
                      Text(
                        "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 22),
                      ),
                    ],
                  ).animate().fadeIn(duration: 2000.milliseconds),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.jm().format(DateTime.now()),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ).animate().fadeIn(duration: 2000.milliseconds),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "${widget.users.firstName} ${widget.users.lastName}",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ).animate().slideX(
                      duration: 2000.milliseconds, curve: Curves.bounceIn),
                  Flexible(
                    child: Row(
                      children: [
                        Text(widget.users.email,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                      ],
                    ).animate().slideX(
                        duration: 2000.milliseconds, curve: Curves.bounceIn),
                  )
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 150,
                  child:
                      Image.asset(greetingPic()),
                ),
              ).animate().fadeIn(duration: 2100.milliseconds),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
 final String image;
  final Color backgroundColor;
  final String text;

  const CategoryIcon(
      {super.key,
      required this.image,
      required this.backgroundColor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 2, color: Colors.grey, spreadRadius: 2)
              ]),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Image.asset(image),
            ),
          ),
        ),
        Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        )
      ],
    );
  }
}
