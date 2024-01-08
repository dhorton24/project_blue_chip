import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../Custom Data/Events.dart';
import '../../Custom Data/Users.dart';

class MyEventsScreen extends StatefulWidget {
  Users users;

  MyEventsScreen({super.key, required this.users});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  late Stream<QuerySnapshot> cartStream;
  List<DocumentSnapshot> cartList = [];

  setUp() async {

    if(!widget.users.admin) {
      cartStream = FirebaseFirestore.instance
        .collection('bookingEvents')
    .where('clientId',isEqualTo: widget.users.id)
        //.orderBy('startTime', descending: true)
        .snapshots();
    }else{
      cartStream = FirebaseFirestore.instance
          .collection('bookingEvents')
        .orderBy('startTime', descending: true)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: setUp(),
    builder: (BuildContext context, AsyncSnapshot text) {
      return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              )),
        ),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, spreadRadius: 6, blurRadius: 5)
                  ]),
              child: Column(
                children: [
                  Center(
                    child: StrokeText(
                      text: 'My Events',
                      textStyle: TextStyle(
                        fontSize: 28,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondary,
                        fontWeight: FontWeight.bold,
                      ),
                      strokeColor: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      strokeWidth: 3,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Text("Select an event to choose an option. Select a date to change availability or to show that day's events.",textAlign: TextAlign.center,style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary,fontSize: 16),),
                  // ),
                ],
              ),
            ).animate().slide(duration: 1500.milliseconds),
            Expanded(
              child: StreamBuilder(
                stream: cartStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  //if there is an error
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  //while it connects
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  cartList = snapshot.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          BookingEvents thisBookingEvent = BookingEvents(
                              startTime: (cartList[index]['startTime']as Timestamp).toDate(),
                              firstName: cartList[index]['firstName'],
                              lastName: cartList[index]['lastName'],
                              id: cartList[index]['id'],
                              complete: cartList[index]['complete'],
                              approved: cartList[index]['approved'],
                              depositPaid: cartList[index]['depositPaid'],
                              paidInFull: cartList[index]['paidInFull'],
                              phoneNumber: cartList[index]['phoneNumber'],
                              clientId: cartList[index]['clientId'],
                              clientEmail: cartList[index]['clientEmail'],
                              description: cartList[index]['description'],
                              length: cartList[index]['length'],
                              eventName: cartList[index]['eventName'],
                              eventLocation: cartList[index]['eventLocation'],
                              amountOfGuest: cartList[index]['amountOfGuest'],
                              total: cartList[index]['total']);

                          return MyEventCell(bookingEvents: thisBookingEvent);

                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox();
                        },
                        itemCount: cartList.length),
                  );
                },
              ),
            )
          ],
        ),
      );

  });
  }
}


class MyEventCell extends StatefulWidget {

  final BookingEvents bookingEvents;

  const MyEventCell({super.key, required this.bookingEvents});

  @override
  State<MyEventCell> createState() => _MyEventCellState();
}

class _MyEventCellState extends State<MyEventCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: const [
            BoxShadow(color: Colors.grey,
            spreadRadius: 3,
            blurRadius: 3,
            offset: Offset(0, 5))
          ]
        ),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.bookingEvents.firstName} ${widget.bookingEvents.lastName}",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                        Text("Date: ${widget.bookingEvents.startTime.month}/${widget.bookingEvents.startTime.day}/${widget.bookingEvents.startTime.year}",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary)),
                        Text("Guest: ${widget.bookingEvents.amountOfGuest}",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                        Text("Location: ${widget.bookingEvents.eventLocation}",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                        Text("Hours Needed: ${widget.bookingEvents.length}",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),

                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: [
                          Text("Approved: ",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary)),
                          widget.bookingEvents.approved ?
                              Text("Yes",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary)):
                              Text("No",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary)),

                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: [
                          Text("Complete: ",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary)),


                          widget.bookingEvents.approved ?
                          Text("Yes",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary)):
                          Text("No",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary))
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Deposit Paid: ",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary)),


                          widget.bookingEvents.depositPaid ?
                          Text("Yes",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary)):
                          Text("No",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary))
                        ],
                      ),

                      Text("Phone: ${widget.bookingEvents.phoneNumber}",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                      Text("Email: ${widget.bookingEvents.clientEmail}",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),


                    ],
                  )

                ],

              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Event ID: ${widget.bookingEvents.id}",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),textAlign: TextAlign.center,),
              ),

            ],
          ),
        ),

      ),
    );
  }
}

