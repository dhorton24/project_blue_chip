import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_chip/Widgets/Picture%20Header.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../Custom Data/Item.dart';
import '../../Custom Data/Users.dart';
import '../../Widgets/AddToMenuModal.dart';
import '../LogIn/SignInScreen.dart';

class SelectedItemScreen extends StatefulWidget {
  final Item item;
  final Users users;
  final bool datePicked;
  final List<DateTime> blackoutDates;

  const SelectedItemScreen(
      {super.key, required this.item, required this.users, required this.datePicked,required this.blackoutDates});

  @override
  State<SelectedItemScreen> createState() => _SelectedItemScreenState();
}

class _SelectedItemScreenState extends State<SelectedItemScreen> {
  String? url;

  setUp() async {
    if (widget.item.picLocation != null && widget.item.picLocation != 'null') {
      var ref =
          FirebaseStorage.instance.ref().child(widget.item.picLocation ?? "");

      print(widget.item.picLocation);
      try {
        await ref.getDownloadURL().then((value) => setState(() {
              url = value;

              //url = 'https://${url!}';
            }));
      } on FirebaseStorage catch (e) {
        print('Did not get URL: ${e}');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: null,
        builder: (BuildContext context, AsyncSnapshot text) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                //stack button on top of widget
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    //Custom widget
                    PictureHeader(
                      picLocation: widget.item.picLocation!,
                      headerName: widget.item.itemName,
                      containerLength: 2,
                      withBorder: false,
                      withTitle: false,
                      customPic: true,
                      item: widget.item,
                    ),

                    //back button
                    SafeArea(
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.white,
                            ))),
                  ],
                ),

                //item info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StrokeText(
                          text: widget.item.itemName,
                          textStyle: TextStyle(
                            fontSize: 48,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          strokeColor: Colors.white,
                          strokeWidth: 1,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8.0, right: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: Colors.grey,
                                    size: 17,
                                  ),
                                  Text(
                                    "Gluten Free",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.category_outlined,
                                      color: Colors.grey, size: 17),
                                  Text(
                                    "Nachos",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.grey),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Text(
                          widget.item.itemDescription,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Ingredients: Corn Tortilla, onions, peppers, & white cheese dip.(Preset Ingredients)",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.white)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("\$${widget.item.retail.toStringAsFixed(2)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(color: Colors.white)),
                              widget.users.firstName != 'Guest'
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7)))),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return AddToMenuModal(
                                                item: widget.item,
                                                users: widget.users,
                                                datePicked: widget.datePicked,
                                                blackoutDates: widget.blackoutDates,
                                              );
                                            });
                                      },
                                      child: Text(
                                        "Add to menu",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                      ))
                                  : ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          Theme.of(context).colorScheme.secondary),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(7)))),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const SignInScreen()),
                                            (route) => false);
                                  },
                                  child: Text(
                                    "Sign in / Sign up",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
