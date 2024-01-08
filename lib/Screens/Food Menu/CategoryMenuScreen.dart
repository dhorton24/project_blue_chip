
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:project_blue_chip/Custom%20Data/TestData.dart';
import 'package:project_blue_chip/Screens/Food%20Menu/AdminMenu/AddItemScreen.dart';

import 'package:stroke_text/stroke_text.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../../Custom Data/Item.dart';
import '../../Custom Data/Users.dart';
import 'MyCustomMenu.dart';
import 'SelectedCategoryScreen.dart';


class CategoryMenuScreen extends StatefulWidget {
  final Users users;


  const CategoryMenuScreen({super.key, required this.users,});

  @override
  State<CategoryMenuScreen> createState() => _CategoryMenuScreenState();
}

class _CategoryMenuScreenState extends State<CategoryMenuScreen> {
  TestData testData = TestData();

  List<Item> cartList = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(

        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          widget.users.admin?
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddItemScreen()));
              },
              icon: const Icon(
                Icons.admin_panel_settings_outlined,
                color: Colors.white,
              )):
              const SizedBox()

        ],
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
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 6,
                        blurRadius: 5)
                  ]),
              child: Center(
                child: StrokeText(
                  text: 'Explore Food Menu',
                  textStyle: TextStyle(
                    fontSize: 28,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                  strokeColor: Theme.of(context).colorScheme.primary,
                  strokeWidth: 3,
                ),
              ),
            ).animate().slide(duration: 1500.milliseconds),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Categories",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                children: [
                  Text("Select a category from the following options.",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                ],
              ),
            ),


         Container(
           //color: Colors.grey[300],
           height: 445,
           child: ListView.builder(itemBuilder: (BuildContext context, int index)

           {
             return Padding(
               padding: const EdgeInsets.all(8.0),
               child: CategoryImageTile(image: testData.categoryPicLocation[index], categoryName: testData.categoryName[index],index: index,users: widget.users,),
             );
           },itemCount: testData.categoryName.length,
           scrollDirection: Axis.horizontal,),
         ),

          ],

        ),
      ),
    );
  }


}

class CategoryImageTile extends StatelessWidget {
  final String image;
  final String categoryName;
  final int index;
  final Users users;



   CategoryImageTile({
    super.key,
    required this.image,
    required this.categoryName,
     required this.index,
     required this.users
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [

          Container(
            height: 325,
            width: MediaQuery.of(context).size.width/1.5,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.all(Radius.circular(20),),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 3,
                  blurRadius: 15,
                 offset: Offset(0.0, 20),
                  color: Colors.grey
                )
              ]
            ),
        ),
          Container(
            height: 400,
            width: MediaQuery.of(context).size.width/1.5,
            color: Colors.transparent,
            child: Column(

              children: [
                Container(
                    width: MediaQuery.of(context).size.width-150,
                    height: 200,
                    child: Image.asset(image),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(categoryName,style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.primary),),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Gluten-free",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Served with sides",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectedCategoryScreen(picLocation: image, title: categoryName,users: users)));
                      }, icon: Icon(Icons.arrow_forward_ios_outlined,size: 26,color: Theme.of(context).colorScheme.primary,),style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey)
                      ),)
                    ),
                  ],
                )
              ],
            ),
          ),


        ],
      ),
    ).animate().slideY(duration: (800.milliseconds * (index == 0 ? .7 : index)));
  }
}

class CategoryTile extends StatelessWidget {
  final String title;
  final String picLocation;

  const CategoryTile({super.key, required this.title, required this.picLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.primary,
                blurRadius: 8,
                spreadRadius: 2)
          ]),
      child: Column(
        children: [
          Container(
            height: 75,
            width: 75,
            child: Image.asset(
              picLocation,
              fit: BoxFit.fill,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primary),
          )
        ],
      ),
    );
  }
}
