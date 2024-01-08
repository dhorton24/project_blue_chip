import 'package:flutter/material.dart';
import 'package:project_blue_chip/Custom%20Data/Events.dart';
import 'package:project_blue_chip/Firebase/BookingEventsFirebase.dart';
import 'package:stroke_text/stroke_text.dart';

class SelectedEventScreen extends StatefulWidget {
  final BookingEvents bookingEvents;

  const SelectedEventScreen({super.key, required this.bookingEvents});

  @override
  State<SelectedEventScreen> createState() => _SelectedEventScreenState();
}

class _SelectedEventScreenState extends State<SelectedEventScreen> {
  BookingEventsFirebase bookingEventsFirebase = BookingEventsFirebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                boxShadow: [
                  BoxShadow(color: Colors.grey, spreadRadius: 6, blurRadius: 5)
                ]),
            child: Column(
              children: [
                Center(
                  child: StrokeText(
                    text: 'Event Options',
                    textStyle: TextStyle(
                      fontSize: 32,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    strokeColor: Theme.of(context).colorScheme.primary,
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
          Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                            'Event Info:',
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                            textAlign: TextAlign.center,
                          ),
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              eventInfo(context),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Event description: ${widget.bookingEvents.description}',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            ],
          ),
const Spacer(),
          buttons(context)

        ],
      ),
    );
  }

  Widget buttons(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50)),
          boxShadow: [
            BoxShadow(color: Colors.grey, spreadRadius: 6, blurRadius: 5)
          ]),
      child: Center(
        child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        bookingEventsFirebase
                            .completeEvent(widget.bookingEvents)
                            .whenComplete(() => {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Event Completed"))),
                          Navigator.pop(context)
                        });
                      },
                      child: const Text("Event Completed")),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {


                        showDialog(context: context, builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Choose an Option",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary,)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(onPressed: () async {
                                await  bookingEventsFirebase.createBlackOutDate(widget.bookingEvents.startTime, false);

                                  bookingEventsFirebase
                                      .approveEvent(widget.bookingEvents)
                                      .whenComplete(() => {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Event Approved"))),
                                    Navigator.pop(context)
                                  });
                                }, child: const Text("Accept & Blackout Date",textAlign: TextAlign.center,)),
                                ElevatedButton(onPressed: (){
                                  bookingEventsFirebase
                                      .approveEvent(widget.bookingEvents)
                                      .whenComplete(() => {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Event Approved"))),
                                    Navigator.pop(context)
                                  });
                                }, child: const Text("Accept")),
                                ElevatedButton(onPressed: (){}, child: const Text("Cancel"))

                              ],
                            ),
                          );
                        });

                      },
                      child: const Text("Accept Event")),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Delete Event?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                      color:
                                      Theme.of(context).colorScheme.primary),
                                  textAlign: TextAlign.center,
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "This can not be undone. Customer will be told the event was deleted.",
                                      style: Theme.of(context).textTheme.displaySmall,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          bookingEventsFirebase
                                              .deleteEvent(widget.bookingEvents)
                                              .whenComplete(() => {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Event Deleted"))),
                                            Navigator.pop(context),
                                            Navigator.pop(context)
                                          });
                                        },
                                        child: const Text("Delete")),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"))
                                  ],
                                ),
                              );
                            });
                      },
                      child: const Text("Delete Event")),
                ),
              ],
            ),
      ),
    );
  }

  Widget eventInfo(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.secondary,
                      spreadRadius: 3,
                      blurRadius: 4)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Event name: ${widget.bookingEvents.eventName}',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Event location: ${widget.bookingEvents.eventLocation}',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Event completed: ',
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                        ),
                        widget.bookingEvents.complete ?
                        Text("Yes",
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary)):
                        Text("No",
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary))
                      ],
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Deposit paid: ',
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                        ),
                        widget.bookingEvents.depositPaid ?
                        Text("Yes",
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary)):
                        Text("No",
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary))
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Phone number: ${widget.bookingEvents.phoneNumber}',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Email: ${widget.bookingEvents.clientEmail}',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Hours needed for event: ${widget.bookingEvents.length}',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Amount of guest: ${widget.bookingEvents.amountOfGuest}',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Customer: ${widget.bookingEvents.firstName} ${widget.bookingEvents.lastName}',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Event Approved: ',
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),
                        ),
                        widget.bookingEvents.approved ?
                            Text("Yes",
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary)):
                            Text("No",
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
