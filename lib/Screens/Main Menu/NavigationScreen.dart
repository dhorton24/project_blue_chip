import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_chip/Screens/Contact/ContactUsScreen.dart';
import 'package:project_blue_chip/Screens/Food%20Menu/CategoryMenuScreen.dart';
import 'package:project_blue_chip/Screens/Main%20Menu/MainMenuScreen.dart';
import 'package:project_blue_chip/Screens/Schedule/Admin/AdminScheduleScreen.dart';
import 'package:project_blue_chip/Screens/Schedule/OpenSchedule.dart';
import 'package:project_blue_chip/Screens/Schedule/ScheduleScreen.dart';
import 'package:project_blue_chip/Screens/Settings/Settings.dart';

import '../../Custom Data/BlackOutDates.dart';
import '../../Custom Data/Users.dart';
import '../../Firebase/BookingEventsFirebase.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NavigationScreen extends StatefulWidget {
  Users users;

  NavigationScreen({required this.users});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  List<DateTime> blackoutDates = [];
  BookingEventsFirebase bookingEventsFirebase = BookingEventsFirebase();
  int _selectedIndex = 4;

  var pages = [];

  setUp() async {
    final docRef = FirebaseFirestore.instance
        .collection('blackOutDates')
        .withConverter(
            fromFirestore: BlackOutDates.fromFireStore,
            toFirestore: (BlackOutDates blackOutDates, options) =>
                blackOutDates.toFireStore())
        .get()
        .then((value) async => {
              value.docs.forEach((element) {
                blackoutDates.add(element.data().startTime);
                print("${element.data().startTime}");
              }),
              // print("Black out")
            });

    bookingEventsFirebase.getAllEvents();

    pages = [
       ContactUsScreen(users: widget.users,),

      //if user is not a guest and is not an admin
      if (widget.users.firstName != 'Guest' && !widget.users.admin)
        OpenSchedule(users: widget.users, blackoutDates: blackoutDates)

      //if user is not a guest and is not and admin
      else if (widget.users.firstName != 'Guest' && widget.users.admin)
        AdminScheduleScreen(
            blackOutDate: blackoutDates, bookingFirebase: bookingEventsFirebase)
      else //if user is a guest

        ScheduleScreen(
            blackoutDates: blackoutDates,
            users: widget.users,
            eventName: '',
            eventLocation: '',
            amountOfGuest: 0),


      CategoryMenuScreen(users: widget.users),
      mySettings(users: widget.users,),
      MainMenuScreen(users: widget.users),
    ];
  }

  List<NavItem> _navItems = [
    NavItem(icon: Icons.phone_outlined, title: 'Home'),
    NavItem(icon: Icons.calendar_month_outlined, title: 'Calendar'),
    NavItem(icon: Icons.fastfood_outlined, title: 'Menu'),
    NavItem(icon: Icons.settings_outlined, title: 'Settings'),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            extendBody: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 4;
                });
              },
              child: const Icon(Icons.home_filled),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BottomAppBar(
                shadowColor: Colors.black,
                elevation: 12,
                color: Theme.of(context).colorScheme.primary,
                shape: const AutomaticNotchedShape(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  // StadiumBorder()
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _navItems.map((item) {
                    var index = _navItems.indexOf(item);
                    return index.isOdd
                        ? IconButton(
                                onPressed: () {
                                  _onNavItemTapped(
                                    index,
                                  );
                                },
                                icon: Icon(
                                  item.icon,
                                  color: _selectedIndex == index
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.black,
                                ))
                            .animate()
                            .slideX(
                                curve: Curves.easeIn,
                                duration: 3000.milliseconds)
                        : IconButton(
                                onPressed: () {
                                  _onNavItemTapped(
                                    index,
                                  );
                                },
                                icon: Icon(
                                  item.icon,
                                  color: _selectedIndex == index
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.black,
                                ))
                            .animate()
                            .slideX(
                                curve: Curves.easeInBack,
                                duration: 3000.milliseconds);
                  }).toList(),
                ),
              ).animate().fadeIn(duration: 2000.milliseconds),
            ),
            body: pages[_selectedIndex],
          );
        });
  }
}

class NavItem {
  IconData icon;
  String title;

  NavItem({required this.icon, required this.title});
}
