import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_blue_chip/Screens/LogIn/SignInScreen.dart';
import 'package:project_blue_chip/Screens/Main%20Menu/MainMenuScreen.dart';

import '../../Custom Data/Users.dart';
import '../../Enums/CreateAccount Status.dart';
import '../../Firebase/UserFirebase.dart';
import '../../Widgets/TextFields.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController password = TextEditingController();

  UsersFirebase usersFirebase = UsersFirebase();

  Users users = Users(
      firstName: '',
      lastName: '',
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
    return Scaffold(
      backgroundColor: Colors.black,
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('lib/Images/IMG_8528.JPG').animate().flip(),
            )),
            Container(
              height: MediaQuery.of(context).size.height/1.6,
        
              decoration: const BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50))
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Row(
                        children: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                          Text("Have an account?",style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 18,color: Theme.of(context).colorScheme.primary),)
                        ],
                      ),


                      TextFields(text: 'First Name', textEditingController: firstController,textInputType: TextInputType.text,),
                      TextFields(text: 'Last Name', textEditingController: lastController,textInputType: TextInputType.text),
                      TextFields(text: 'Email', textEditingController: emailController,textInputType: TextInputType.emailAddress),
                      TextFields(text: 'Phone', textEditingController: phoneController,textInputType: TextInputType.phone),
                      TextFields(text: 'Password', textEditingController: password,textInputType: TextInputType.text,isPassword: true,),
        
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
        
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primary)
                                  ),
        
                                  onPressed: () async {

                                    setState(() {
                                      users.firstName = firstController.text;
                                      users.lastName = lastController.text;
                                      users.email = emailController.text;
                                    });

                                    if (firstController.text.isEmpty ||
                                        lastController.text.isEmpty ||
                                        emailController.text.isEmpty ||
                                        password.text.isEmpty) {

                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Fill out required fields")));

                                    } else {

                                      CreateAccountStatus status = await usersFirebase.createUser(
                                          users, password.text);

                                      if(status == CreateAccountStatus.emailInUse){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Email In use")));
                                      }else if(status == CreateAccountStatus.weakPassword){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Weak Password")));
                                      }else if(status == CreateAccountStatus.passwordNotLongEnough){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Password not long enough")));
                                      }else if(status == CreateAccountStatus.incorrectEmailFormat){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Email not correctly formatted")));
                                      }else if(status == CreateAccountStatus.success){


                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("Signed in with ${users.email}")));

                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainMenuScreen(users: users,)));


                                      }

                                    }
                                  }, child: Text('Sign Up',style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.secondary,fontSize: 28),)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().slideY()
          ],
        ),
      ),
    );
  }
}
