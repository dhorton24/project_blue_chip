import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_chip/Custom%20Data/BlackOutDates.dart';
import 'package:project_blue_chip/Firebase/BookingEventsFirebase.dart';
import 'package:stroke_text/stroke_text.dart';


class BlackoutDateScreen extends StatefulWidget {
  const BlackoutDateScreen({super.key});

  @override
  State<BlackoutDateScreen> createState() => _BlackoutDateScreenState();
}

class _BlackoutDateScreenState extends State<BlackoutDateScreen> {

  Stream<QuerySnapshot> cartStream = FirebaseFirestore.instance.collection('blackOutDates').orderBy('startTime',descending: true).snapshots();
  List<DocumentSnapshot> cartList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,leading: IconButton(
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
                color: Colors.grey,
                spreadRadius: 6,
                blurRadius: 5)
          ]),
        child: Column(
          children: [
            Center(
              child: StrokeText(
                text: 'Blackout Dates',
                textStyle: TextStyle(
                  fontSize: 28,
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

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Select a date to choose an option.",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary),),
          ),

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
                        BlackOutDates thisBlackoutDates = BlackOutDates(startTime:( cartList[index]['startTime']as Timestamp).toDate(), isAllDay: cartList[index]['isAllDay'],id: cartList[index]['id']);

                       return DateCell(blackOutDates: thisBlackoutDates);
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
  }
}


class DateCell extends StatefulWidget {

  final BlackOutDates blackOutDates;
  const DateCell({super.key, required this.blackOutDates});

  @override
  State<DateCell> createState() => _DateCellState();
}

class _DateCellState extends State<DateCell> {
  BookingEventsFirebase bookingEventsFirebase = BookingEventsFirebase();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text("Remove Blackout Date?",style: Theme.of(context).textTheme.displayMedium,textAlign: TextAlign.center,),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(onPressed: (){
                    bookingEventsFirebase.deleteBlackoutDate(widget.blackOutDates).whenComplete(() => {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Date updated."))),
                      Navigator.pop(context)
                    });

                  }, child: Text("Delete")),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Cancel"))

                ],
              ),
            );
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 4,
                offset: Offset(0.0,5)
              )
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Date: ${widget.blackOutDates.startTime.month}/${widget.blackOutDates.startTime.day}/${widget.blackOutDates.startTime.year}",style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 20),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

