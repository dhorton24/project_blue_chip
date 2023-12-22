import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_blue_chip/Custom%20Data/BlackOutDates.dart';
import 'package:project_blue_chip/Custom%20Data/Events.dart';
import 'package:uuid/uuid.dart';

import '../Custom Data/Item.dart';
import '../Custom Data/Users.dart';

class BookingEventsFirebase {
  var firestore = FirebaseFirestore.instance;

  // setTimeForEvent(DateTime dateTime, Users users){
  //
  //   var uuid = const Uuid();
  //   var id = uuid.v4();
  //
  //   BookingEvents bookingEvents = BookingEvents(startTime: dateTime,length: 1, firstName: users.firstName, lastName: users.lastName, id: id, complete: false, approved: false, depositPaid: false, paidInFull: false, phoneNumber: users.phoneNumber, clientId: users.id, clientEmail: users.email, description: '');
  //
  //
  //   final docRef = firestore.collection('bookingEvents').doc(id).withConverter(
  //       fromFirestore: BookingEvents.fromFireStore,
  //       toFirestore: (BookingEvents bookingEvents, options) => bookingEvents.toFireStore());
  //
  //   docRef.set(bookingEvents);
  // }

  Future addItemToUserMenu(Users users, Item item) async {
    var uuid = const Uuid();
    var id = uuid.v4();

    final docRef = firestore
        .collection('users')
        .doc(users.id)
        .collection('menu')
        .doc(item.itemID)
        .withConverter(
            fromFirestore: Item.fromFireStore,
            toFirestore: (Item item, options) => item.toFireStore());

    docRef.set(item);
  }

  Future updateServingAmountOnItem(Users users, Item item) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('menu')
        .doc(item.itemID);

    docRef.update({'servingSize': item.servingSize});
    getTotalServingSize(users);
    getMenuTotal(users);
  }

  Future deleteItemFromMenu(Users users, Item item) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('menu')
        .doc(item.itemID);

    await docRef.delete();
    getTotalServingSize(users);
    getMenuTotal(users);
  }

  num servingSize = 0;

  Future getTotalServingSize(Users users) async {
    servingSize = 0;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('menu')
        .withConverter(
            fromFirestore: Item.fromFireStore,
            toFirestore: (Item item, options) => item.toFireStore());

    final tempRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .withConverter(
            fromFirestore: Item.fromFireStore,
            toFirestore: (Item item, options) => item.toFireStore());

    docRef.get().then((value) async => {
          for (var docSnapShot in value.docs)
            {
              print("size ${docSnapShot.data().servingSize}"),
              servingSize = servingSize + docSnapShot.data().servingSize!
            },
          tempRef.update({"totalServingSize": servingSize})
        });

    return servingSize;
  }

  Future getMenuTotal(Users users) async {
    num cartTotal = 0;

    //ref to update user total
    final tempRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .withConverter(
            fromFirestore: Item.fromFireStore,
            toFirestore: (Item item, options) => item.toFireStore());

    //ref to get menu items
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('menu')
        .withConverter(
            fromFirestore: Item.fromFireStore,
            toFirestore: (Item item, options) => item.toFireStore());

    docRef.get().then((value) async => {
          for (var docSnapShot in value.docs)
            {
              if (docSnapShot.data().onSale)
                {
                  //if item is on sale
                  cartTotal = cartTotal + docSnapShot.data().salePrice!
                }
              else
                {
                  cartTotal = cartTotal +
                      (docSnapShot.data().retail *
                          docSnapShot.data().servingSize!)
                }
            },
          tempRef.update({"cartTotal": cartTotal})
        });
  }

  Future createBlackOutDate(DateTime startTime, bool isAllDay) async {
    BlackOutDates blackOutDates =
        BlackOutDates(startTime: startTime, isAllDay: isAllDay);

    var uuid = const Uuid();
    var id = uuid.v4();

    //create ref for blackoutDates
    final docRef = FirebaseFirestore.instance
        .collection('blackOutDates')
        .doc(id)
        .withConverter(
            fromFirestore: BlackOutDates.fromFireStore,
            toFirestore: (BlackOutDates blackOutDates, options) =>
                blackOutDates.toFireStore());

    docRef.set(blackOutDates);
  }

  Future uploadEvent(DateTime startTime, int length, Users users,
      String eventName, String eventLocation, int amountOfGuest) async {
    var uuid = const Uuid();
    var id = uuid.v4();

    BookingEvents bookingEvents = BookingEvents(
        startTime: startTime,
        firstName: users.firstName,
        lastName: users.lastName,
        id: id,
        complete: false,
        approved: false,
        depositPaid: false,
        paidInFull: false,
        phoneNumber: users.phoneNumber,
        clientId: users.id,
        clientEmail: users.email,
        description: '',
        length: length,
        eventName: eventName,
        eventLocation: eventLocation,
        amountOfGuest: amountOfGuest,
    total: '');

    final docRef = FirebaseFirestore.instance
        .collection('bookingEvents')
        .doc(id)
        .withConverter(
            fromFirestore: BookingEvents.fromFireStore,
            toFirestore: (BookingEvents bookingEvents, options) =>
                bookingEvents.toFireStore());

    docRef.set(bookingEvents);
  }

  List<BookingEvents> bookingEvents = [];
  getAllEvents(){

    bookingEvents.clear();

    final docRef = FirebaseFirestore.instance
        .collection('bookingEvents').withConverter(
        fromFirestore: BookingEvents.fromFireStore,
        toFirestore: (BookingEvents bookingEvents, options) => bookingEvents.toFireStore()).get().then((value) async => {
      value.docs.forEach((element) {
        bookingEvents.add(element.data());
      }),
      print("bookingEvents length ${bookingEvents.length}")
    });
  }

  ///empty shopping cart
  Future clearShoppingCart(Users users) async {
    //ref to delete
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(users.id)
        .collection('menu');

    var newRef;

    final docSnap = docRef.get();

    docSnap.then((value) => {
          for (var docSnapShot in value.docs)
            {
              newRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(users.id)
                  .collection('menu')
                  .doc(docSnapShot.id)
                  .delete(),
            }
        });

    getMenuTotal(users);
    getTotalServingSize(users);
  }
}
