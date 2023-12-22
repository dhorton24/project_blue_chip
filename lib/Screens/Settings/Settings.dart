import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../Widgets/TextButtons.dart';




class mySettings extends StatefulWidget {
  const mySettings({super.key});

  @override
  State<mySettings> createState() => _mySettingsState();
}

class _mySettingsState extends State<mySettings> {


  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
          title: StrokeText(
            text: 'Settings',
            textStyle: TextStyle(
              fontSize: 48,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
            strokeColor: Theme.of(context).colorScheme.primary,
            strokeWidth: 3,
          ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            )),
      ),

      body: Column(
        children: [
          Image.asset('lib/Images/IMG_8528.JPG').animate().flip(),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Dedrick Horton",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.secondary),),
          ),

          ElevatedButton(onPressed: (){

          }, child: Text('Edit Profile',style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary,fontSize: 22),),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary)
          ),),


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active_outlined,color: Theme.of(context).colorScheme.secondary,),
                    Text("Notifications",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.secondary,fontSize: 18),),
                  ],
                ).animate().fadeIn(),

                Switch(
                    inactiveThumbColor: Colors.grey,
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: notifications, onChanged: (value)=>{
                      setState((){
                        notifications = value;
                      })
                }).animate().fadeIn()
              ],
            ),
          ),

          TextButtons(iconData: Icons.privacy_tip_outlined,text: 'Privacy',).animate().fadeIn(),
          TextButtons(iconData: Icons.person_2_outlined,text: 'Account',).animate().fadeIn(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Powered by',style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.secondary, fontSize: 16),),
              Container(
                  height: 100,
                  width:100,
                  child: Image.asset('lib/Images/CITex_noBack.png'))
            ],
          )

        ],
      ),
    );
  }
}


