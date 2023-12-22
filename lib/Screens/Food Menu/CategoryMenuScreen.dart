
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
  final bool datePicked;    //to decide if schedule has been picked yet
  final List<DateTime> blackoutDates; //blackout dates

  const CategoryMenuScreen({super.key, required this.users,required this.datePicked,required this.blackoutDates});

  @override
  State<CategoryMenuScreen> createState() => _CategoryMenuScreenState();
}

class _CategoryMenuScreenState extends State<CategoryMenuScreen> {
  TestData testData = TestData();

  List<Item> cartList = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: StrokeText(
          text: 'Food Menu',
          textStyle: TextStyle(
            fontSize: 32,
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
        actions: [
          widget.users.admin?
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItemScreen()));
              },
              icon: const Icon(
                Icons.admin_panel_settings_outlined,
                color: Colors.white,
              )):

              widget.users.firstName != 'Guest'?
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCustomMenu(users: widget.users,)));
              },
              icon: const Icon(
                Icons.list_alt_outlined,
                color: Colors.white,
              )):
                  const SizedBox()

        ],
      ),
      body: Column(
        children: [
          Image.asset('lib/Images/IMG_8528.JPG').animate().flip(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Select from the following category options",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ResponsiveGridList(
                rowMainAxisAlignment: MainAxisAlignment.center,
                horizontalGridSpacing: 16,
                verticalGridSpacing: 16,
                minItemsPerRow: 2,
                maxItemsPerRow: 2,
                listViewBuilderOptions: ListViewBuilderOptions(),
                minItemWidth: 165,
                children: List.generate(
                    testData.categoryName.length,
                    (index) => InkWell(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectedItemScreen(client: widget.client, item: itemList[index])));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectedCategoryScreen(
                                          picLocation:
                                              testData.categoryPicLocation[index],
                                          title: testData.categoryName[index],
                                          cartList: cartList,
                                      users: widget.users,
                                      datePicked: widget.datePicked,
                                      blackoutDates: widget.blackoutDates,
                                        )));
                          },
                          child: CategoryTile(
                            title: testData.categoryName[index],
                            picLocation: testData.categoryPicLocation[index],
                          ),
                        )),
              ),
            ),
          ).animate().fadeIn(),
        ],
      ),
    );
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
            height: 100,
            width: 100,
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
