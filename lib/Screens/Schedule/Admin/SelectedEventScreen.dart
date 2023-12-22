import 'package:flutter/material.dart';
import 'package:project_blue_chip/Custom%20Data/Events.dart';
import 'package:stroke_text/stroke_text.dart';




class SelectedEventScreen extends StatefulWidget {
  final BookingEvents bookingEvents;

  const SelectedEventScreen({super.key, required this.bookingEvents});

  @override
  State<SelectedEventScreen> createState() => _SelectedEventScreenState();
}

class _SelectedEventScreenState extends State<SelectedEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: StrokeText(
          text: 'Event Options',
          textStyle: TextStyle(
            fontSize: 32,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
          strokeColor: Theme.of(context).colorScheme.primary,
          strokeWidth: 3,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            )),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Event Info:',style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.secondary,),textAlign: TextAlign.center,)),
          eventInfo(context)
        ],
      ),
    );
  }

  Widget eventInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.secondary,
                  spreadRadius: 3,
                  blurRadius: 4
                )
              ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Event name: ${widget.bookingEvents.eventName}',style: Theme.of(context).textTheme.bodyLarge,),
                  Text('Event location: ${widget.bookingEvents.eventLocation}',style: Theme.of(context).textTheme.bodyLarge,),
                  Text('Event completed: ${widget.bookingEvents.complete}',style: Theme.of(context).textTheme.bodyLarge,),
                  Text('Deposit paid: ${widget.bookingEvents.depositPaid}',style: Theme.of(context).textTheme.bodyLarge,),
                  Text('Paid in full: ${widget.bookingEvents.paidInFull}',style: Theme.of(context).textTheme.bodyLarge,),
                  Text('Phone number: ${widget.bookingEvents.phoneNumber}',style: Theme.of(context).textTheme.bodyLarge,),
                  Text('Email: ${widget.bookingEvents.clientEmail}',style: Theme.of(context).textTheme.bodyLarge,),
                  Text('Hours needed for event: ${widget.bookingEvents.length}',style: Theme.of(context).textTheme.bodyLarge,),
                  Text('Amount of guest: ${widget.bookingEvents.amountOfGuest}',style: Theme.of(context).textTheme.bodyLarge,),
                  Text('Customer: ${widget.bookingEvents.firstName} ${widget.bookingEvents.lastName}',style: Theme.of(context).textTheme.bodyLarge,),
                  Text('Event description: ${widget.bookingEvents.description}',style: Theme.of(context).textTheme.bodyLarge,),

                ],
              ),
            ),
          ),
    );
  }
}
