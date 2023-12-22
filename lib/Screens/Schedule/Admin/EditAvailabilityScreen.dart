import 'package:flutter/material.dart';
import 'package:project_blue_chip/Firebase/BookingEventsFirebase.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:intl/intl.dart';

class EditAvailabilityScreen extends StatefulWidget {
  final CalendarTapDetails details;

  const EditAvailabilityScreen({super.key, required this.details});

  @override
  State<EditAvailabilityScreen> createState() => _EditAvailabilityScreenState();
}

class _EditAvailabilityScreenState extends State<EditAvailabilityScreen> {
  BookingEventsFirebase bookingEventsFirebase = BookingEventsFirebase();

  Time _time = Time(hour: 11, minute: 30, second: 0);

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  DateTime startingTime = DateTime.now();
  DateTime endingTime = DateTime.now();
  bool isAllDay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: StrokeText(
          text: 'Edit Availability',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Editing date: ${widget.details.date!.month}/${widget.details.date!.day}/${widget.details.date!.year}",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Please enter the time frame for this date that you are unavailable.",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                    "Beginning Time Frame: ${DateFormat.jm().format(startingTime)}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(showPicker(
                          value: _time,
                          onChange: onTimeChanged,
                          onChangeDateTime: (DateTime dateTime) {
                            startingTime = dateTime;
                          }));
                    },
                    child: Text("Edit Starting Time"))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                    "Beginning Time Frame: ${DateFormat.jm().format(endingTime)}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(showPicker(
                          value: _time,
                          onChange: onTimeChanged,
                          onChangeDateTime: (DateTime dateTime) {
                            endingTime = dateTime;
                          }));
                    },
                    child: Text("Edit Starting Time"))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isAllDay = !isAllDay;
                      });
                    },
                    child: Text("Unavailable all day")),
                isAllDay
                    ? Text("Currently unavailable all day.",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.secondary))
                    : Text("Currently available during all or some of the day.",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.secondary))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {

                  //update date and then show snackbar
                //   await bookingEventsFirebase
                //       .createBlackOutDate(startingTime, endingTime, isAllDay)
                //       .whenComplete(() => {
                //             ScaffoldMessenger.of(context).showSnackBar(
                //               const SnackBar(
                //                 content: Text('Date Updated'),
                //               ),
                //             ),
                //             Navigator.pop(context)
                //           });
                 },
                child: Text("Submit")),
          )
        ],
      ),
    );
  }
}
