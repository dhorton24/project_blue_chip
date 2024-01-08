import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_blue_chip/Firebase/UserFirebase.dart';
import 'package:project_blue_chip/Widgets/TextFields.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../Custom Data/Users.dart';

class EditAccountScreen extends StatefulWidget {
  Users users;

  EditAccountScreen({super.key, required this.users});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {


  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  UsersFirebase usersFirebase = UsersFirebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(color: Colors.grey, spreadRadius: 6, blurRadius: 5)
                  ]),
              child: Column(
                children: [
                  Center(
                    child: StrokeText(
                      text: 'Edit Account',
                      textStyle: TextStyle(
                        fontSize: 28,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                      strokeColor: Theme.of(context).colorScheme.primary,
                      strokeWidth: 3,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Text("Select an event to choose an option. Select a date to change availability or to show that day's events.",textAlign: TextAlign.center,style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary,fontSize: 16),),
                  // ),
                ],
              ),
            ).animate().slide(duration: 1500.milliseconds),
        
        
            TextFields(text: 'Edit First Name', textEditingController: firstController, textInputType: TextInputType.text),
            TextFields(text: 'Edit Last Name', textEditingController: lastController, textInputType: TextInputType.text),
            TextFields(text: 'Edit Phone Number', textEditingController: phoneController, textInputType: TextInputType.phone),
        
            ElevatedButton(onPressed: (){
              if(firstController.text.isNotEmpty || firstController.text != ''){
                setState(() {
                  widget.users.firstName = firstController.text;
                });
              }
              if(lastController.text.isNotEmpty || lastController.text != ''){
                setState(() {
                  widget.users.lastName = lastController.text;
                });
              }
              if(phoneController.text.isNotEmpty || phoneController.text != ''){
                setState(() {
                  widget.users.phoneNumber = phoneController.text;
                });
              }

              usersFirebase.updateUser(widget.users).whenComplete(() =>
              {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully updated"))),
                Navigator.pop(context)
              });

            }, child: Text("Update")),

          ],
        ),
      ),
    );
  }
}
