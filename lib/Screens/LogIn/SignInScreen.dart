import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_blue_chip/Screens/LogIn/SignUpScreen.dart';
import 'package:project_blue_chip/Screens/Main%20Menu/MainMenuScreen.dart';
import 'package:project_blue_chip/Screens/Main%20Menu/NavigationScreen.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../Custom Data/Users.dart';
import '../../Enums/Sign In Status.dart';
import '../../Firebase/UserFirebase.dart';
import '../../Widgets/TextFields.dart';
import 'dart:io' show Platform;


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UsersFirebase usersFirebase = UsersFirebase();

  Users users = Users(
      firstName: 'Guest',
      lastName: 'Account',
      email: '',
      birthday: DateTime.now(),
      id: '',
      token: '',
      activeAccount: true,
      admin: false,
      phoneNumber: '',
      notificationsOn: true,
      totalServingSize:0);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.black,
                Colors.black,
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                Colors.black,
                Colors.black,
              ])),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Padding(
                          padding: const EdgeInsets.only(bottom: 32.0, top: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                              child: Container(
                                  height:100,
                                  child: Hero(
                                      tag: 'Hero',
                                      child: Image.asset('lib/Images/Nacho Momma Abbreviated Banner.JPG').animate().slide(duration: 1000.milliseconds)))),
                        ),
                        StrokeText(
                          text: 'Sign in to your account',
                          textStyle: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                          strokeColor: Theme.of(context).colorScheme.primary,
                          strokeWidth: 3,
                        ).animate().slide(duration: 1000.milliseconds),

                        if(Platform.isAndroid)
                        googleButton(context).animate().slide(duration: 1000.milliseconds),
                        //appleButton(context),
                        // Row(
                        //   children: [
                        //     const Flexible(child: Divider()),
                        //     Padding(
                        //       padding: const EdgeInsets.all(16.0),
                        //       child: StrokeText(
                        //         text: 'Or continue with',
                        //         textStyle: TextStyle(
                        //           fontSize: 16,
                        //           color: Theme.of(context).colorScheme.secondary,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //         strokeColor:
                        //             Theme.of(context).colorScheme.primary,
                        //         strokeWidth: 3,
                        //       ),
                        //     ),
                        //     const Flexible(child: Divider()),
                        //   ],
                        // ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: const Divider(thickness: 2,),
                        ),
                        TextFields(
                          text: 'Email',
                          textEditingController: emailController,
                          textInputType: TextInputType.emailAddress,
                        ).animate().fadeIn(duration: 1000.milliseconds, delay: 1500.milliseconds),
                        TextFields(
                          text: 'Password',
                          textEditingController: passwordController,
                          textInputType: TextInputType.text,
                          isPassword: true,
                        ).animate().fadeIn(duration: 1000.milliseconds, delay: 1500.milliseconds),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                    onPressed: () async {
                                      if (emailController.text.isEmpty ||
                                          passwordController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Please fill out all fields")));
                                      } else {
                                        SignInStatus status =
                                            await usersFirebase.signIn(
                                                emailController.text,
                                                passwordController.text);

                                        if (status == SignInStatus.invalidEmail) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Invalid email. If you created an account with google or apple, sign in using one of those options.")));
                                        } else if (status ==
                                            SignInStatus.disabled) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Account disabled. If you created an account with google or apple, sign in using one of those options.")));
                                        } else if (status ==
                                            SignInStatus.userNotFound) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "User not found. If you created an account with google or apple, sign in using one of those options.")));
                                        } else if (status ==
                                            SignInStatus.wrongPassword) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Wrong password. If you created an account with google or apple, sign in using one of those options.")));
                                        } else if (status ==
                                            SignInStatus.invalidCred) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Invalid Credentials. If you created an account with google or apple, sign in using one of those options.")));

                                        } else if (status ==
                                            SignInStatus.success) {

                                          users = await usersFirebase.getUser();

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Sign In with ${users.email}")));

                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen(users: users,)));

                                        }
                                      }
                                    },
                                    child: Text(
                                      'Log In',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: 28),
                                    )).animate().fadeIn(duration: 1000.milliseconds, delay: 1500.milliseconds),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8, left: 24, right: 24),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Signed is as a guest")));


                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen(users: users,)));
                                    },
                                    child: Text(
                                      'Continue as guest',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: 28),textAlign: TextAlign.center
                                    )),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 1000.milliseconds, delay: 1500.milliseconds),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignUpScreen()));
                            },
                            child: const Text(
                              "Create an account",
                              style:
                                  TextStyle(decoration: TextDecoration.underline),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 2300.milliseconds),
      ),
    );
  }

  Padding googleButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 42.0, left: 42, top: 12),
      child: ElevatedButton(
        onPressed: () async {
         users =  await usersFirebase.signInWithGoogle();

         if(users.firstName != "Guest" && users.firstName != ''){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen(users: users,)));

           ScaffoldMessenger.of(context)
               .showSnackBar(SnackBar(content: Text("Sign In with ${users.email}")));

         }else{
           ScaffoldMessenger.of(context)
               .showSnackBar(const SnackBar(content: Text("Failed to sign in")));
         }




        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
            maximumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width, 50)),
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
            ),
            side: MaterialStateProperty.all(
                BorderSide(color: Colors.black.withOpacity(.35), width: 2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 30,
                child: Image.asset('lib/Images/google-1088004_1920.png')),
            Flexible(
              child: Text("Connect with Google",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary),textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Padding appleButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 42.0, left: 42, top: 12),
      child: ElevatedButton(
        onPressed: () async {
          //show success message
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Sign In with")));
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
            maximumSize: MaterialStateProperty.all(
                Size(MediaQuery.of(context).size.width, 50)),
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
            ),
            side: MaterialStateProperty.all(
                BorderSide(color: Colors.black.withOpacity(.35), width: 2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 30,
                child: Image.asset(
                    'lib/Images/apple-logo-52C416BDDD-seeklogo.com.png')),
            Flexible(
              child: Text("Connect with Apple",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary),textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
    );
  }
}
