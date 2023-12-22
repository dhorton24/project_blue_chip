import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_chip/Firebase/BookingEventsFirebase.dart';

import '../Custom Data/Item.dart';
import '../Custom Data/Users.dart';
import '../Screens/Schedule/OpenSchedule.dart';

class AddToMenuModal extends StatefulWidget {
  final Item item;
  final Users users;
  final bool datePicked;
  final List<DateTime> blackoutDates;

  const AddToMenuModal({super.key, required this.item, required this.users,required this.datePicked,required this.blackoutDates});

  @override
  State<AddToMenuModal> createState() => _AddToMenuModalState();
}

class _AddToMenuModalState extends State<AddToMenuModal> {
  String? url;

  BookingEventsFirebase bookingEventsFirebase = BookingEventsFirebase();

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

  List<DropdownMenuItem<num>> servingSize = [
    const DropdownMenuItem(
      value: 20,
      child: Text("20"),
    ),
    const DropdownMenuItem(
      value: 40,
      child: Text("40"),
    ),
    const DropdownMenuItem(
      value: 60,
      child: Text("60"),
    ),
    const DropdownMenuItem(
      value: 80,
      child: Text("80"),
    ),
    const DropdownMenuItem(
      value: 100,
      child: Text("100"),
    ),
    const DropdownMenuItem(
      value: 120,
      child: Text("120"),
    ),
    const DropdownMenuItem(
      value: 140,
      child: Text("140"),
    ),
    const DropdownMenuItem(
      value: 160,
      child: Text("160"),
    ),
    const DropdownMenuItem(
      value: 180,
      child: Text("180"),
    ),
    const DropdownMenuItem(
      value: 200,
      child: Text("200"),
    ),
  ];

  num selectedSize = 20;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: null,
        builder: (BuildContext context, AsyncSnapshot text) {
          return Container(
            margin: const EdgeInsets.all(16),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 4, color: Theme.of(context).primaryColor)
                ],
                color: Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                 ! widget.datePicked?
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Please select date from schedule screen",style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
                      Column(
                        children: [
                          ElevatedButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (
                                context) =>
                                OpenSchedule(
                                  users: widget.users, blackoutDates: widget.blackoutDates,)));
                          }, child: Text('Go to Schedule Screen'))
                        ],
                      )
                    ],
                  ):

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(
                        widget.item.itemDescription,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.black),
                      )),
                      SizedBox(
                        height: 80,
                        width: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),

                            ///TODO null safety... provide 'no picture' picture
                            child: url != null
                                ? Image.network(
                                    url.toString(),
                                    fit: BoxFit.fill,
                                  )
                                : const CircularProgressIndicator()),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Select Serving Size",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  )),
                          DropdownButton(
                            items: servingSize,
                            onChanged: (num? newValue) {
                              setState(() {
                                selectedSize = newValue ?? 0;
                              });
                            },
                            value: selectedSize,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "\$${widget.item.retail.toStringAsFixed(2)}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7)))),
                                onPressed: () {
                                  setState(() {
                                    widget.item.servingSize = selectedSize;
                                  });

                                  bookingEventsFirebase
                                      .addItemToUserMenu(
                                          widget.users, widget.item)
                                      .whenComplete(() =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "${widget.item.itemName} added to cart!"),
                                            ),
                                          ));

                                  Navigator.pop(context);
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
                                )),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
