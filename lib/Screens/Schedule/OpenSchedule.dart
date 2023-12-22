import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_blue_chip/Screens/Schedule/ScheduleScreen.dart';
import 'package:project_blue_chip/Widgets/TextFields.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../Custom Data/Users.dart';
import '../../Widgets/EventCell.dart';



class OpenSchedule extends StatefulWidget {
  final Users users;
  final List<DateTime> blackoutDates;

  const OpenSchedule({super.key, required this.users, required this.blackoutDates});

  @override
  State<OpenSchedule> createState() => _OpenScheduleState();
}

class _OpenScheduleState extends State<OpenSchedule> {



  //List<Meeting> meetings = [];

  TextEditingController amountOfGuestController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  // List<Meeting> _getDataSource(){
  //
  //   DateTime today = DateTime.now();
  //   DateTime startTime = DateTime(today.year, today.month, today.day);
  //   DateTime endTime = startTime.add(const Duration(hours: 2));
  //
  //
  //  // meetings.add(Meeting('Business Launch', startTime, endTime, Theme.of(context).primaryColor, true));
  //
  //   meetings = <Meeting>[ Meeting('Business Launch', DateTime.now(), DateTime.now().add(const Duration(hours: 2)), Colors.black, true)];
  //   return meetings;
  // }




  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  CalendarController calendarController = CalendarController();

  @override
  void initState(){
    super.initState();

    phoneController.text = widget.users.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: StrokeText(
          text: 'Schedule',
          textStyle: TextStyle(
            fontSize: 48,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
          strokeColor: Theme.of(context).colorScheme.primary,
          strokeWidth: 3,
        ).animate().fadeIn(),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            )),
        actions: [
          // IconButton(onPressed: (){
          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>ScheduleScreen()));
          // }, icon: Icon(Icons.admin_panel_settings_outlined,color: Theme.of(context).colorScheme.secondary,))
        ],
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0,bottom: 16),
                child: Container(
                  height: 200,
                  width: 200,
                  child:CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Image.asset('lib/Images/calendar-152046_1920.png')),
                ).animate().flip(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 3,
                        color: Theme.of(context).colorScheme.secondary
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Enter all fields. You may be contacted before approval",textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary,fontSize: 22),),

                        TextFields(text: 'Event name', textEditingController: eventNameController, textInputType: TextInputType.text),

                        TextFields(text: 'Enter event location', textEditingController: locationController, textInputType: TextInputType.text),
                        TextFields(text: 'Enter amount of guests expected', textEditingController: amountOfGuestController, textInputType: TextInputType.number),
                        TextFields(text: 'Enter amount of hours needed', textEditingController: hoursController, textInputType: TextInputType.number),
                        TextFields(text: 'Enter phone number', textEditingController: phoneController, textInputType: TextInputType.phone),

                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(onPressed: (){
                                if(eventNameController.text.isEmpty || eventNameController.text == ''){
                                  returnSnackBar('Enter event name');
                                }
                                else if(locationController.text.isEmpty || locationController.text == ''){
                                  returnSnackBar('Enter event location');
                                }
                                else if(amountOfGuestController.text.isEmpty || amountOfGuestController.text == ''){
                                  returnSnackBar('Enter amount of guests');
                                }
                                else if(hoursController.text.isEmpty || hoursController.text == ''){
                                  returnSnackBar('Enter hours needed');
                                }
                                else{
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ScheduleScreen(blackoutDates: widget.blackoutDates,users: widget.users, eventName: eventNameController.text, eventLocation: eventNameController.text, amountOfGuest: int.parse(amountOfGuestController.text),)));
                                }

                              }, child: Text("Select Date")),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ).animate().slide(),
              )
        
        
        
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Theme.of(context).primaryColor,
              //           blurRadius: 9,
              //           spreadRadius: 10
              //         )
              //       ]
              //     ),
              //     height: MediaQuery.of(context).size.height/2,
              //     child: SfCalendar(
              //       minDate: DateTime.now(),
              //      backgroundColor: Colors.grey[700],
              //
              //      todayTextStyle: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.secondary),
              //      // controller: calendarController,
              //       cellBorderColor: Colors.black,
              //       view: CalendarView.month,
              //       blackoutDatesTextStyle: TextStyle(
              //         color: Colors.red
              //       ),
              //       monthViewSettings: const MonthViewSettings(
              //           showAgenda: false,
              //           appointmentDisplayMode:
              //           MonthAppointmentDisplayMode.appointment),
              //      dataSource: MeetingDataSource(_getDataSource()),
              //       //data source to add events to calendar
              //       timeSlotViewSettings: const TimeSlotViewSettings(
              //           startHour: 8,
              //           endHour: 16,
              //           ),
              //       onLongPress: null,
              //       onTap: calendarTapped,
              //       showDatePickerButton: true,
              //     ),
              //   ),
              // ).animate().slide(),
              //
              // Expanded(
              //   child: ListView.builder(
              //       padding: EdgeInsets.zero,
              //       itemCount: meetings.length,
              //       itemBuilder: (BuildContext context, int index) {
              //         return GestureDetector(
              //             onTap: (){
              //             },
              //             child: EventCell(meeting: meetings[index],));
              //       }),
              // )
            ],
          ),
        ),
      )
    );
  }

   returnSnackBar(String text){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> calendarTapped(CalendarTapDetails details) async {
    print("Tapped: ${details.appointments}");



  }

}







// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Meeting> source) {
//     appointments = source;
//   }
//
//   @override
//   DateTime getStartTime(int index) {
//     return appointments![index].from;
//   }
//
//   @override
//   DateTime getEndTime(int index) {
//     return appointments![index].to;
//   }
//
//   @override
//   String getSubject(int index) {
//     return appointments![index].eventName;
//   }
//
//   @override
//   Color getColor(int index) {
//     return appointments![index].background;
//   }
//
//   @override
//   bool isAllDay(int index) {
//     return appointments![index].isAllDay;
//   }
// }
//
// class Meeting {
//   Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);
//
//   String eventName;
//   DateTime from;
//   DateTime to;
//   Color background;
//   bool isAllDay;
// }