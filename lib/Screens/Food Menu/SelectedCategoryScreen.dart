import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_blue_chip/Custom%20Data/TestData.dart';
import 'package:project_blue_chip/Screens/Food%20Menu/AdminMenu/EditItemScreen.dart';
import 'package:project_blue_chip/Widgets/ItemCell.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../Custom Data/Item.dart';
import '../../Custom Data/Users.dart';
import '../../Widgets/Picture Header.dart';
import 'SelectedItemScreen.dart';

class SelectedCategoryScreen extends StatefulWidget {
  final String picLocation;
  final String title;
  final Users users;


  const SelectedCategoryScreen(
      {super.key, required this.picLocation,
      required this.title,
      required this.users,
      });

  @override
  State<SelectedCategoryScreen> createState() => _SelectedCategoryScreenState();
}

class _SelectedCategoryScreenState extends State<SelectedCategoryScreen> {
  TestData testData = TestData();

  late Stream<QuerySnapshot> cartStream;
  List<DocumentSnapshot> cartList = [];

  setUp() async {
    cartStream = FirebaseFirestore.instance
        .collection('itemCatalog')
        .where('category', isEqualTo: widget.title)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                //custom widget to show image header
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    PictureHeader(
                      picLocation: widget.picLocation,
                      headerName: widget.title,
                      containerLength: 3,
                      withBorder: true, customPic: false,
                      
                    ).animate().fadeIn(duration: 1500.milliseconds),
                    SafeArea(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.white,
                            )))
                  ],
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: cartStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      //if there is an error
                      if (snapshot.hasError) {
                        return const Text('Error');
                      }
                      //while it connects
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      cartList = snapshot.data!.docs;

                      if (cartList.isEmpty) {
                        return Center(
                            child: Text(
                          'Empty Menu.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.center,
                        ));
                      }

                      return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            Item thisItem = Item(
                                itemName: cartList[index]['itemName'],
                                retail: cartList[index]['retail'],
                                itemID: cartList[index]['itemID'],
                                itemDescription: cartList[index]
                                    ['itemDescription'],
                                onSale: cartList[index]['onSale'],
                                picLocation: cartList[index]['picLocation'],
                                amountInCart: cartList[index]['amountInCart'],
                                salePrice: cartList[index]['salePrice'],
                                category: cartList[index]['category']);

                            return GestureDetector(
                              onLongPress: (){
                                if(widget.users.admin){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditItemScreen(item: thisItem,)));
                                }
                              },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SelectedItemScreen(
                                                  item: thisItem,
                                                  users: widget.users,
                                              )));
                                },
                                child: ItemCell(
                                    item: thisItem, users: widget.users,).animate().slideX(duration: 1000.milliseconds));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox();
                          },
                          itemCount: cartList.length);
                    },
                  ),
                ).animate().slide(),
              ],
            ),
          );
        });
  }
}
