import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_blue_chip/Custom%20Data/Events.dart';
import 'package:project_blue_chip/Firebase/BookingEventsFirebase.dart';
import 'package:project_blue_chip/Screens/Schedule/Admin/SelectedEventScreen.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../Widgets/EventCell.dart';

class AdminScheduleScreen extends StatefulWidget {
  List<DateTime> blackOutDate;
  BookingEventsFirebase bookingFirebase;

  AdminScheduleScreen(
      {super.key, required this.blackOutDate, required this.bookingFirebase});

  @override
  State<AdminScheduleScreen> createState() => _AdminScheduleScreenState();
}

class _AdminScheduleScreenState extends State<AdminScheduleScreen> {
  List<Meeting> meetings = [];

  BookingEventsFirebase bookingEventsFirebase = BookingEventsFirebase();
  DateTime selectedDay = DateTime.now();


  List<Meeting> _getDataSource()  {

    meetings.clear();

    DateTime today = DateTime.now();
    DateTime startTime = DateTime(today.year, today.month, today.day);
    DateTime endTime = startTime.add(const Duration(hours: 2));

    // meetings.add(Meeting('Business Launch', startTime, endTime, Theme.of(context).primaryColor, true));


    widget.bookingFirebase.bookingEvents.forEach((element) {
      meetings.add(Meeting(element.eventName, element.startTime,
          element.startTime.add(Duration(hours: element.length)), Theme
              .of(context)
              .colorScheme
              .secondary, false));
    });
    return meetings;
  }


   late Stream<QuerySnapshot> cartStream;
  // = FirebaseFirestore.instance
  //     .collection('bookingEvents').where('startTime',isEqualTo: selectedDay.day)
  //
  //     .snapshots();

  List<DocumentSnapshot> cartList = [];

  setUp() async {
    cartStream = FirebaseFirestore.instance
        .collection('bookingEvents').where('startTime',isGreaterThanOrEqualTo: DateTime(selectedDay.year,selectedDay.month,selectedDay.day))
        .snapshots();


  }

  @override
  void initState() {
    super.initState();

    // cartStream = FirebaseFirestore.instance
    //     .collection('bookingEvents').where('startTime',isGreaterThanOrEqualTo: DateTime(selectedDay.year,selectedDay.month,selectedDay.day))
    //     .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: StrokeText(
                text: 'Adjust Schedule',
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Select an event to choose an option. Select a date to change availability or to show that day's events.",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                              blurRadius: 9,
                              spreadRadius: 10)
                        ]),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2,
                    child: Calendar(context),
                  ),
                ).animate().slide(),

                // Container(
                //     height: MediaQuery
                //         .of(context)
                //         .size
                //         .height / 3,
                //     child: Column(
                //       children: [
                //         Text("Press a date to select an option",style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondary),),
                //         Text("Selected Date: ${selectedDay.month}/${selectedDay.day}",style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondary),),
                //
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Column(
                //             children: [
                //               ElevatedButton(onPressed: (){}, child: Text("Decide on Event")),
                //               ElevatedButton(onPressed: (){}, child: Text("Blackout Date")),
                //
                //             ],
                //           ),
                //         )
                //       ],
                //     )),
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


                      return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            BookingEvents thisEvent = BookingEvents(
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

                            if(thisEvent.startTime.day == selectedDay.day) {  //if event is the same as selected day
                              return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectedEventScreen(bookingEvents: thisEvent,)));
                              },
                                child: EventCell(meeting: thisEvent)
                            );
                            }
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox();
                          },
                          itemCount: cartList.length);
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  SfCalendar Calendar(BuildContext context) {   //calendar
    return SfCalendar(
      minDate: DateTime.now(),
      backgroundColor: Colors.grey[700],

      todayTextStyle: Theme
          .of(context)
          .textTheme
          .bodySmall!
          .copyWith(color: Theme
          .of(context)
          .colorScheme
          .secondary),
      // controller: calendarController,
      cellBorderColor: Colors.black,
      view: CalendarView.month,
      blackoutDatesTextStyle: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
      monthViewSettings: const MonthViewSettings(
          showAgenda: false,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      dataSource: MeetingDataSource(_getDataSource()),
      //data source to add events to calendar
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 8,
        endHour: 16,
      ),
      onLongPress: calendarLongPress,
      onTap: calendarTapped,
      showDatePickerButton: true,
      blackoutDates: widget.blackOutDate,
    );
  }

  Future<void>calendarTapped(CalendarTapDetails details) async{

    //change selected day once tapped
    setState(() {
      selectedDay = details.date!;

      cartStream = FirebaseFirestore.instance
          .collection('bookingEvents').where('startTime',isEqualTo: DateTime(selectedDay.year,selectedDay.month,selectedDay.day))
          .snapshots();
    });
  }

  Future<void> calendarLongPress(CalendarLongPressDetails details) async {
    print("Tapped: ${details.appointments}");

    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${details.date!.day}")));

    optionsDialog(details.date!);
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

                  ElevatedButton(
                      onPressed: () {
                        bookingEventsFirebase
                            .createBlackOutDate(dateTime, true)
                            .whenComplete(() =>
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Date updated')),
                          ),
                          Navigator.pop(context)
                        });
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>EditAvailabilityScreen(details: details,)));
                      },
                      child: const Text("Black out date")),
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

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

}
