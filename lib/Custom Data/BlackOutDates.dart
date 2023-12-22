import 'package:cloud_firestore/cloud_firestore.dart';

class BlackOutDates{

  DateTime startTime; //start time of unavailability

  bool isAllDay;  //if unavailable all day


BlackOutDates({required this.startTime,
required this.isAllDay});

  factory BlackOutDates.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return BlackOutDates(
        startTime: (data?['startTime'] as Timestamp).toDate(),
      isAllDay: data?['isAllDay']
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'startTime': startTime,
      'isAllDay':isAllDay
    };
  }

}