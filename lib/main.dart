import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_blue_chip/Screens/LogIn/LoadPage.dart';
import 'package:project_blue_chip/Screens/LogIn/SignInScreen.dart';
import 'Screens/Main Menu/MainMenuScreen.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);



  Stripe.publishableKey = "pk_test_51OBePwJn90tCGP7svuXgXYtbIoU8lEalnfWLBysRzw9r549ViXBhlEPXpNhqcvj0hPeWZX4pxIv6r2znZHUDzbzF00giw7XWWY";
  Stripe.merchantIdentifier = 'Top Tie';
  await Stripe.instance.applySettings();

  await dotenv.load(fileName: "lib/Keys/.env");


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
