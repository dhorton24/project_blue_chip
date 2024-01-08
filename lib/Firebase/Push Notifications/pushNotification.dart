import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../Custom Data/Users.dart';
import '../../main.dart';

///Include flutter_local_notifications & firebase_messaging
///use auth key and upload to firebase via settings in cloud messaging
///Add the following to android manifest file
///<meta-data
///android:name='com.google.firebase.messaging.default_notification_channel_id'
///android:value = 'high_importance_channel"/>

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}
@pragma('vm:entry-point')
Future<void> handleMessage(RemoteMessage? message) async {
  if (message == null) {
    return null;
  }

  navigatorKey.currentState
      ?.pushNamed('/OpeningAppointmentScreen', arguments: message);
}


class PushNotifications {
  final _firebaseMessaging = FirebaseMessaging.instance;


  // Instance of Flutternotification plugin

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    "High Importance Notifications",
    description: "This channel is used for important notifications",
    importance: Importance.defaultImportance
  );



  // Future<void> setUpInteractedMessage()async{
  //   await _firebaseMessaging.setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true
  //   );
  //
  //
  //   NotificationSettings settings = await _firebaseMessaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true
  //   );
  //
  //   //get messge from notification when app is not in foreground
  //   RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
  //
  //   //This listens for messages when app is in background
  //   FirebaseMessaging.onMessageOpenedApp.listen(_mapMessageToUser);
  //
  //   //Listen to messages in Foreground
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //
  //     //Initialize FlutterLocalNotifications
  //     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  //
  //     const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //       'schedular_channel', // id
  //       'Schedular Notifications', // title
  //       description:
  //       'This channel is used for Schedular app notifications.', // description
  //       importance: Importance.max,
  //     );
  //
  //     await flutterLocalNotificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //         ?.createNotificationChannel(channel);
  //
  //     //Construct local notification using our created channel
  //     if (notification != null && android != null) {
  //       flutterLocalNotificationsPlugin.show(
  //           notification.hashCode,
  //           notification.title,
  //           notification.body,
  //           NotificationDetails(
  //             android: AndroidNotificationDetails(
  //               channel.id,
  //               channel.name,
  //               channelDescription: channel.description,
  //              // icon: "@mipmap/ic_launcher", //Your app icon goes here
  //               // other properties...
  //             ),
  //           ));
  //     }
  //   });
  //
  // }

  // _mapMessageToUser(RemoteMessage message, ){
  //   Map<String, dynamic> json = message.data;
  //
  //   if(message.data['service'] != null){
  //   }
  // }

 void initNotifications() async {

   //get permission to use notifications
    await _firebaseMessaging.requestPermission();

    // var token = await _firebaseMessaging.getToken();
    //
    // print("Debug Token:${token}");


    //handle notifications when app is in background
   //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);




    // Initialization  setting for android

    // const InitializationSettings initializationSettingsAndroid = InitializationSettings(
    //
    //     android: AndroidInitializationSettings("@drawable/ic_launcher"));

    // _localNotificationsPlugin.initialize(
    //
    //   initializationSettingsAndroid,
    //
    //   // to handle event when we receive notification
    //
    //   onDidReceiveNotificationResponse: (details) {
    //
    //     if (details.input != null) {}
    //
    //   },
    //
    // );

    initPushNotification();
    initLocalNotifications();
    //
    // String? token;
    // String? apnsToken;
    //
    // //retrieve token from device
    // if (Platform.isIOS) {
    //   //if ios, must get APNs token first
    //   apnsToken = await _firebaseMessaging.getAPNSToken();
    //
    //   if (apnsToken != null) {
    //     await _firebaseMessaging.subscribeToTopic('Top-Tier');
    //     token = await _firebaseMessaging.getToken();
    //   } else {
    //     await Future<void>.delayed(const Duration(seconds: 3));
    //     token = await _firebaseMessaging.getAPNSToken();
    //     if (token != null) {
    //       await _firebaseMessaging.subscribeToTopic('Top-Tier');
    //       token = await _firebaseMessaging.getToken();
    //     }
    //   }
    // } else {
    //   token = await _firebaseMessaging.getToken();
    // }

    //assign token to client variable
    //client.token = token ?? "";

    //call class method to assign token to user
    //_assignTokenToUser(client);

    //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // initPushNotification();

    // print("Delay has begun");
    // await Future<void>.delayed(
    //     const Duration(
    //         seconds: 3
    //     )
    // ).whenComplete(() => sendPushMessage(token!, 'Test Not', 'You did it')
    // );

    // fcMToken = await _firebaseMessaging.getToken();

  }


  Future initPushNotification() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);


    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message){
      final notification = message.notification;

      if(notification == null){
        return;
      }
      _localNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@/mipmap-xxxhdpi/ic_launcher'
          )
        ),
        payload: jsonEncode(message.toMap())
      );

    });
  }

  Future initLocalNotifications()async{
   const iOS = DarwinInitializationSettings();
   const android = AndroidInitializationSettings('@drawable/launch_background');

   const settings = InitializationSettings(android: android, iOS:iOS);

   await _localNotificationsPlugin.initialize(
     settings,
     onDidReceiveNotificationResponse: (payload){
       final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
       handleMessage(message);
     }
   );

   final platform = _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
   await platform?.createNotificationChannel(_androidChannel);
  }

  //
  // static Future<void> display(RemoteMessage message) async {
  //   // To display the notification in device
  //
  //   try {
  //     print(message.notification!.android!.sound);
  //
  //     final id = DateTime
  //         .now()
  //         .millisecondsSinceEpoch ~/ 1000;
  //
  //     NotificationDetails notificationDetails = NotificationDetails(
  //
  //       android: AndroidNotificationDetails(
  //
  //           message.notification!.android!.sound ?? "Channel Id",
  //
  //           message.notification!.android!.sound ?? "Main Channel",
  //
  //           groupKey: "gfg",
  //
  //           color: Colors.green,
  //
  //           importance: Importance.max,
  //
  //           sound: RawResourceAndroidNotificationSound(
  //
  //               message.notification!.android!.sound ?? "gfg"),
  //
  //
  //           // different sound for
  //
  //           // different notification
  //
  //           playSound: true,
  //
  //           priority: Priority.high),
  //
  //     );
  //
  //     await _localNotificationsPlugin.show(id, message.notification?.title,
  //
  //         message.notification?.body, notificationDetails,
  //
  //         payload: message.data['route']);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  Future getToken() async {
    await _firebaseMessaging.requestPermission();

    String? token;
    String? apnsToken;

    //retrieve token from device
    if (Platform.isIOS) {
      //if ios, must get APNs token first
      apnsToken = await _firebaseMessaging.getAPNSToken();

      if (apnsToken != null) {
        await _firebaseMessaging.subscribeToTopic('nacho-momma');
        token = await _firebaseMessaging.getToken();
      } else {
        await Future<void>.delayed(const Duration(seconds: 3));
        token = await _firebaseMessaging.getAPNSToken();
        if (token != null) {
          await _firebaseMessaging.subscribeToTopic('nacho-momma');
          token = await _firebaseMessaging.getToken();
        }
      }
    } else {
      token = await _firebaseMessaging.getToken();
    }

    print("DEBug Token: ${token}");

    return token;
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAA5y6K_Vg:APA91bHg6xcf7tPfxJMlfSvbf1CEMm0HE8ZuwSImp75RHDSkQIU8PPAuPNaTrEJmYlBXr0ACBZjjOmt8dWzPSqsHR5yh5Sa-pbxET4wUWaGqI0VQ9Fs989y4T3lGMtoTMpSvQRowKNMZ'
          },
          body: jsonEncode(<String, dynamic>{
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'android_channel_id': 'dbfood'
            },
            'to': token
          }));
    } catch (e) {
      print(e);
    }
  }

 // String token = '';

  Future sendPushMessageToAdmins(String body, String title) async {

    Users? users;
    print("Here");

    //create ref in database for each admin user
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .where('admin', isEqualTo: true)
    .where('notificationsOn',isEqualTo: true)
        .withConverter(
            fromFirestore: Users.fromFireStore,
            toFirestore: (Users users, options) => users.toFireStore())
        .get()
        .then((value) => {
              for (var snap in value.docs)
                {
                  users = snap.data(),

                  //send push notification
                  sendPushMessage(snap.data().token, body, title)
                },
            });

    // try{
    //   await http.post(
    //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
    //       headers: <String,String>{
    //         'Content-Type':'application/json',
    //         'Authorization':'key=AAAA5y6K_Vg:APA91bHg6xcf7tPfxJMlfSvbf1CEMm0HE8ZuwSImp75RHDSkQIU8PPAuPNaTrEJmYlBXr0ACBZjjOmt8dWzPSqsHR5yh5Sa-pbxET4wUWaGqI0VQ9Fs989y4T3lGMtoTMpSvQRowKNMZ'
    //       },
    //       body: jsonEncode(
    //           <String,dynamic>{
    //             'priority':'high',
    //             'data':<String, dynamic>{
    //               'click_action':'FLUTTER_NOTIFICATION_CLICK',
    //               'status':'done',
    //               'body':body,
    //               'title':title,
    //             },
    //
    //             'notification':<String, dynamic>{
    //               'title':title,
    //               'body':body,
    //               'android_channel_id':'dbfood'
    //             },
    //             'to':client?.token ?? ""
    //           }
    //       )
    //   );
    // }catch (e){
    //   print (e);
    // }
  }

  Future assignTokenToUser(Users users) async{

    String? token;
    String? apnsToken;


    if (Platform.isIOS) {
      //if ios, must get APNs token first
      apnsToken = await _firebaseMessaging.getAPNSToken();

      if (apnsToken != null) {
        await _firebaseMessaging.subscribeToTopic('nacho-momma');
        token = await _firebaseMessaging.getToken();
      } else {
        await Future<void>.delayed(const Duration(seconds: 3));
        token = await _firebaseMessaging.getAPNSToken();
        if (token != null) {
          await _firebaseMessaging.subscribeToTopic('nacho-momma');
          token = await _firebaseMessaging.getToken();
        }
      }
    } else {
      token = await _firebaseMessaging.getToken();
    }

    //get user ref to database
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: Users.fromFireStore,
            toFirestore: (Users users, options) => users.toFireStore());

    users.token = token??"";

    print("DEBUG TOKEN: ${token}");
    docRef.update({'token': users.token});
  }
}
