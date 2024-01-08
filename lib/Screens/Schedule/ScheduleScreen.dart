import 'dart:convert';

import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:project_blue_chip/Firebase/BookingEventsFirebase.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../Custom Data/Users.dart';
import '../LogIn/SignInScreen.dart';
import 'package:http/http.dart' as http;

class ScheduleScreen extends StatefulWidget {
  final List<DateTime> blackoutDates;
  final Users users;
  final String eventName;
  final String eventLocation;
  final int amountOfGuest;

  ScheduleScreen(
      {required this.blackoutDates,
      required this.users,
      required this.eventName,
      required this.eventLocation,
      required this.amountOfGuest});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final now = DateTime.now();
  late BookingService mockBookingService;

  BookingEventsFirebase bookingEventsFirebase = BookingEventsFirebase();
  late DateTime startTime;

  List<DateTime> disabledDates = [];
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
    // DateTime.now().startOfDay
    // DateTime.now().endOfDay
    mockBookingService = BookingService(
        serviceName: 'Mock Service',
        serviceDuration: 30,
        bookingEnd: DateTime(now.year, now.month, now.day, 18, 0),
        bookingStart: DateTime(now.year, now.month, now.day, 7, 0));
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    setState(() {
      startTime = newBooking.bookingStart;
    });

    if (widget.users.firstName == 'Guest') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false);
    } else {
      makePayment(50.00);

      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Event Sent! Please wait for confirmation."))),
    }

    print("Pressed");
    // await Future.delayed(const Duration(seconds: 1));
    // converted.add(DateTimeRange(
    //     start: newBooking.bookingStart, end: newBooking.bookingEnd));
    // print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    ///take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
    ///disabledDays will properly work with real data
    DateTime first = now;
    DateTime tomorrow = now.add(const Duration(days: 1));
    DateTime second = now.add(const Duration(minutes: 55));
    DateTime third = now.subtract(const Duration(minutes: 240));
    DateTime fourth = now.subtract(const Duration(minutes: 500));

    // converted.add(
    //     DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
    // converted.add(DateTimeRange(
    //     start: second, end: second.add(const Duration(minutes: 23))));
    // converted.add(DateTimeRange(
    //     start: third, end: third.add(const Duration(minutes: 15))));
    // converted.add(DateTimeRange(
    //     start: fourth, end: fourth.add(const Duration(minutes: 50))));
    //
    // //book whole day example
    // converted.add(DateTimeRange(
    //     start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 5, 0),
    //     end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 0)));
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      // DateTimeRange(
      //     start: DateTime(now.year, now.month, now.day, 12, 0),
      //     end: DateTime(now.year, now.month, now.day, 13, 0))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: null,
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Colors.white,
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
                            color: Colors.grey,
                            spreadRadius: 6,
                            blurRadius: 5)
                      ]),
                  child: Center(
                    child: StrokeText(
                      text: 'Choose a Date',
                      textStyle: TextStyle(
                        fontSize: 28,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                      strokeColor: Theme.of(context).colorScheme.primary,
                      strokeWidth: 3,
                    ),
                  ),
                ).animate().slide(duration: 1500.milliseconds),

                widget.users.firstName == 'Guest'?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Sign in to book an event.",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                    ):
                    const SizedBox(),


                Expanded(
                    child: calendar().animate().slideY(duration: 1000.milliseconds)
                ),
              ],
            ),
          );
        });
  }

  Widget calendar() {
    return Center(
      child: BookingCalendar(
        bookingService: mockBookingService,
        bookingExplanation: Text(''),
        convertStreamResultToDateTimeRanges: convertStreamResultMock,
        getBookingStream: getBookingStreamMock,
        uploadBooking: uploadBookingMock,
        pauseSlots: generatePauseSlots(),
        pauseSlotText: 'LUNCH',
        hideBreakTime: false,
        loadingWidget: const Text('Fetching data...'),
        uploadingWidget: const CircularProgressIndicator(),
        locale: 'en_US',
        startingDayOfWeek: StartingDayOfWeek.monday,
        wholeDayIsBookedWidget:
            const Text('Sorry, for this day everything is booked'),
        disabledDates: widget.blackoutDates,
        bookingButtonText:
            widget.users.firstName != 'Guest' ? 'Book' : 'Sign in / Sign up',
        availableSlotColor: Theme.of(context).colorScheme.primary,
        availableSlotTextStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.secondary),

        //disabledDays: [6, 7],
      ),
    );
  }

  Future<void> makePayment(num total) async {
    print("${dotenv.env['STRIPE_SECRET']}");

    var newTotal = total.toStringAsFixed(2).toString().replaceAll('.', '');
    try {
      //payment intent
      paymentIntent = await createPaymentIntent(newTotal, 'USD');

      //initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Nacho Momma\'s',
        ),
      );

      //display payment sheet
      displayPaymentSheet();
    } catch (error) {
      print("Here: ${error}");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      //make post request to stripe
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body);
      print("${json.decode(response.body)}");
      return json.decode(response.body);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) async => {
                //upload new event when on success
                await bookingEventsFirebase
                    .uploadEvent(startTime, 1, widget.users, widget.eventName,
                        widget.eventLocation, widget.amountOfGuest)
                    .whenComplete(
                      () => {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Successfully paid!'))),
                        Navigator.pop(context),

                      },
                    )
              })
          .onError((error, stackTrace) => {throw Exception(error)});
    } catch (error) {}
    StripeException(error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error processing payment")));
    }
  }
}
