import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_blue_chip/Screens/LogIn/LoadPage.dart';
import 'package:project_blue_chip/Screens/LogIn/SignInScreen.dart';
import 'Firebase/Push Notifications/pushNotification.dart';
import 'Screens/Main Menu/MainMenuScreen.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);



  Stripe.publishableKey = "pk_test_51OBePwJn90tCGP7svuXgXYtbIoU8lEalnfWLBysRzw9r549ViXBhlEPXpNhqcvj0hPeWZX4pxIv6r2znZHUDzbzF00giw7XWWY";
  Stripe.merchantIdentifier = 'Nacho Momma';
  await Stripe.instance.applySettings();

  await dotenv.load(fileName: "lib/Keys/.env");

  await FirebaseMessaging.instance
      .requestPermission();



  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    //_child = RetailSelectionScreen(client: client);
    PushNotifications().initNotifications();

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Nacho Momma\'s',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,



        //text theme throughout app
        textTheme: TextTheme(


            labelLarge: GoogleFonts.bungee(
        textStyle: TextStyle(
        fontSize: 18,
            //fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor)),

            bodySmall: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: 14,
                    //fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),


            titleMedium: GoogleFonts.sofia(
                textStyle: TextStyle(
                    fontSize: 22,
                    //fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            bodyMedium: GoogleFonts.courgette(
                textStyle: TextStyle(
                    fontSize: 14,
                    //fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor)),
            displaySmall: GoogleFonts.bungee(
                textStyle: const TextStyle(
              fontSize: 12,
            )),
            displayMedium: GoogleFonts.sofia(
                textStyle: const TextStyle(
              fontSize: 48,
            )),
            displayLarge: GoogleFonts.courgette(
                textStyle: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor))),

        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff6AE2E0),
            primary: const Color(0xffbb2795),
            secondary: const Color(0xff6AE2E0)),
        useMaterial3: true,
      ),
      home: const LoadPage(),
    );
  }
}
