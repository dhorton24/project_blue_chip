import 'package:flutter/material.dart';

import '../../Custom Data/PageView.dart';
import 'SignInScreen.dart';

class SlidesScreen extends StatefulWidget {
  const SlidesScreen({super.key});

  @override
  State<SlidesScreen> createState() => _SlidesScreenState();
}

class _SlidesScreenState extends State<SlidesScreen> {

  FirstTimeItems firstTimeItems = FirstTimeItems();


  @override
  Widget build(BuildContext context) {
    return Scaffold(


        body: PageView.builder(
            itemCount: firstTimeItems.firstTimeItems().length,
            itemBuilder: (BuildContext context, int index){

              FirstTimeUse thisItem = firstTimeItems.firstTimeItems()[index];
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: thisItem.backgroundColor,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SignInScreen()), (route) => false);
                        }, child: Text("Skip",style: TextStyle(
                            color: Colors.black
                        ),))
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height *.3,
                      child: Image.asset(thisItem.image),
                    ),
                    Column(
                      children: [
                        Text(thisItem.title,style: Theme.of(context).textTheme.displayMedium!.copyWith(color: thisItem.textColor,fontWeight: FontWeight.bold),),

                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(thisItem.text,style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.black,fontSize: 18),),
                        ),
                        if(index == firstTimeItems.firstTimeItems().length-1)
                          Row(
                            children: [
                              TextButton(onPressed: (){                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SignInScreen()), (route) => false);
                              }, child: Text("Get Started",style: TextStyle(color: Colors.white),)),
                              IconButton(onPressed: (){                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SignInScreen()), (route) => false);
                              }, icon: Icon(Icons.arrow_forward_outlined,color: Colors.white,),padding: EdgeInsets.zero,)
                            ],
                          ),
                      ],
                    ),



                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 10,

                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: firstTimeItems.firstTimeItems().length,
                          itemBuilder: (BuildContext context, int i){
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(

                                width: index == i ? 40: 20,
                                color: index == i ? Colors.white70: Colors.white30,
                              ),
                            );
                          }),
                    )


                  ],
                ),
              );
            })

      // Center(
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(20),
      //     child: SizedBox(
      //
      //       height: 200,
      //       width: 200,
      //       child: Hero(
      //           tag: 'Hero',
      //           child: Image.asset('lib/Images/NachoMommaAppIcon.png')),
      //     ),
      //   ),
      // ),
    );
  }
}
