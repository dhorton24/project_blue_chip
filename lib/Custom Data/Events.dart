import 'package:cloud_firestore/cloud_firestore.dart';

class BookingEvents {
  DateTime startTime;

  String firstName;
  String lastName;
  String id;
  bool complete; //is event completed
  bool approved; //has event been approved by admin
  bool depositPaid; //if depositPaid
  bool paidInFull; //if event is fully paid
  String phoneNumber;
  String clientId;
  String clientEmail;
  String description;
  int length;
  String eventName;
  String eventLocation;
  int amountOfGuest;

  String total; //to hold total $ for order

  BookingEvents(
      {required this.startTime,

      required this.firstName,
      required this.lastName,
      required this.id,
      required this.complete,
      required this.approved,
      required this.depositPaid,
      required this.paidInFull,
      required this.phoneNumber,
      required this.clientId,
      required this.clientEmail,
      required this.description,
      required this.length,
      required this.eventName,
        required this.eventLocation,
        required this.amountOfGuest,
        required this.total
      });

  factory BookingEvents.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return BookingEvents(
        startTime: (data?['startTime'] as Timestamp).toDate(),

        firstName: data?['firstName'],
        lastName: data?['lastName'],
        id: data?['id'],
        complete: data?['complete'],
        approved: data?['approved'],
        depositPaid: data?['depositPaid'],
        phoneNumber: data?['phoneNumber'],
        clientId: data?['clientId'],
        clientEmail: data?['clientEmail'],
        description: data?['description'],
        paidInFull: data?['paidInFull'],
    length: data?['length'],
    eventName: data?['eventName'],
      eventLocation: data?['eventLocation'],
      amountOfGuest: data?['amountOfGuest'],
      total: data?['total']
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'startTime': startTime,

      'firstName': firstName,
      'lastName': lastName,
      'id': id,
      'complete': complete,
      'approved': approved,
      'depositPaid': depositPaid,
      'paidInFull': paidInFull,
      'phoneNumber': phoneNumber,
      'clientId': clientId,
      'clientEmail': clientEmail,
      'description': description,
      'length':length,
      'eventName':eventName,
      'eventLocation':eventLocation,
      'amountOfGuest':amountOfGuest,
      'total':total
    };
  }
}
