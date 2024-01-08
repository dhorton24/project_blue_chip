import 'package:flutter/material.dart';

class FirstTimeUse{

  String image;
  Color backgroundColor;
  Color textColor;
  String title;
  String text;


  FirstTimeUse({required this.image,
  required this.backgroundColor,
    required this.textColor,
  required this.title,
  required this.text});




}



class FirstTimeItems{

  Color primary = const Color(0xffbb2795);
  Color secondary = const Color(0xff6AE2E0);


   List<FirstTimeUse> firstTimeItems(){
     List<FirstTimeUse> thisList = <FirstTimeUse>[
      FirstTimeUse(image: 'lib/Images/FirstTime/nachos-8152413_1920.png', backgroundColor: secondary, title: "An All Gluten-Free Menu", text: 'Choose from nachos, fajitas, enchiladas and more in our entire gluten-free menu.', textColor: primary),
       FirstTimeUse(image: 'lib/Images/FirstTime/apron-2814565_1920.png', backgroundColor: primary, title: "Book a Catering Event", text: 'Select from a live calendar to book  catering services.', textColor: secondary),
       FirstTimeUse(image: 'lib/Images/FirstTime/anniversary-157248_1920.png', backgroundColor: Colors.grey, title: "Get Started!", text: 'Continue as a guest to browse options or sign in to access all features and book your catering services today!', textColor: primary)

     ];

    return thisList;
  }
}