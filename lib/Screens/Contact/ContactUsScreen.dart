import 'package:flutter/material.dart';
import 'package:project_blue_chip/Widgets/TextFields.dart';

import '../../Custom Data/Users.dart';



class ContactUsScreen extends StatefulWidget {

  final Users users;

   ContactUsScreen({super.key, required this.users});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController messageController = TextEditingController();


  @override
  void initState(){
    super.initState();

    nameController.text = '${widget.users.firstName} ${widget.users.lastName}';
    emailController.text = widget.users.email;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   automaticallyImplyLeading: false,
      //
      // ),

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
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 6,
                        blurRadius: 5)
                  ]),
              // height: MediaQuery.of(context).size.height * .35,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Image.asset('lib/Images/IMG_8528.JPG'),
              ),
            ),
        
        
            Text("Contact Us",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary),),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Email us below to ask about services with catering and booking options.",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),textAlign: TextAlign.center,),
            ),

            ElevatedButton(onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email Sent! (Email not actually sent, test dialog)")));
            }, child: Text("Send")),
        
            TextFields(text: 'Name', textEditingController: nameController, textInputType: TextInputType.text),
            TextFields(text: 'Email', textEditingController: emailController, textInputType: TextInputType.text),
        
            TextFields(text: 'Message', textEditingController: messageController, textInputType: TextInputType.text),




          ],
        ),
      ),
    );
  }
}
