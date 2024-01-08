import 'package:flutter/material.dart';
import 'package:project_blue_chip/Custom%20Data/Events.dart';

import '../Firebase/BookingEventsFirebase.dart';
import '../Screens/Schedule/Admin/AdminScheduleScreen.dart';



class EventCell extends StatefulWidget {

  BookingEvents meeting;
  EventCell({super.key, required this.meeting});

  @override
  State<EventCell> createState() => _EventCellState();
}

class _EventCellState extends State<EventCell> {

  BookingEventsFirebase bookingEventsFirebase = BookingEventsFirebase();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary,
              blurRadius: 5,
              spreadRadius: 5
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              
              CircleAvatar(
              child: Image.asset('lib/Images/calendar-152046_1920.png'),
                radius: 30,
              ),
              
              Column(

                children: [
                  Text(widget.meeting.eventName,style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold),),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.meeting.startTime.month}/${widget.meeting.startTime.day}/${widget.meeting.startTime.year}",style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondary,)),
                      ),





                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text("${widget.meeting.to.hour}-${widget.meeting.from.hour}",style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondary,)),
                      // ),


                    ],
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> optionsDialog(DateTime dateTime) {
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text(
                "Choose from the list of options",
                style: Theme
                    .of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary, fontSize: 22),
                textAlign: TextAlign.center,
              ),
              actions: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        child: const Text("Decide on events")),

                    // ElevatedButton(
                    //     onPressed: () {
                    //       bookingEventsFirebase
                    //           .createBlackOutDate(dateTime, true)
                    //           .whenComplete(() =>
                    //       {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(content: Text('Date updated')),
                    //         ),
                    //         Navigator.pop(context)
                    //       });
                    //       //Navigator.push(context, MaterialPageRoute(builder: (context)=>EditAvailabilityScreen(details: details,)));
                    //     },
                    //     child: const Text("Black out date")),

                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"))
                  ],
                )
              ],
            ));
  }
}