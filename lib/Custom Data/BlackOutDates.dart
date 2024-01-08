import 'package:cloud_firestore/cloud_firestore.dart';

class BlackOutDates{

  DateTime startTime; //start time of unavailability

  bool isAllDay;  //if unavailable all day

  String id;


BlackOutDates({required this.startTime,
required this.isAllDay,
required this.id});

  factory BlackOutDates.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return BlackOutDates(
        startTime: (data?['startTime'] as Timestamp).toDate(),
      isAllDay: data?['isAllDay'],
      id: data?['id']
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'startTime': startTime,
      'isAllDay':isAllDay,
      'id':id
    };
  }

}