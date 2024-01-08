import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';

import '../Custom Data/Item.dart';




class PictureHeader extends StatefulWidget {

  final String picLocation;
  final String headerName;

  final num containerLength;
  final bool withBorder;
  final bool? withTitle;
  final bool customPic;

  final Item? item;

  const PictureHeader({
    super.key,
    required this.picLocation,
    required this.headerName,
   required this.containerLength,
    required this.withBorder,
    this.withTitle,
    required this.customPic,
    this.item
  });

  @override
  State<PictureHeader> createState() => _PictureHeaderState();
}

class _PictureHeaderState extends State<PictureHeader> {
  String? url;

  setUp() async {
    if(widget.item != null) {
      if (widget.item!.picLocation != null && widget.item!.picLocation != 'null') {
        var ref =
        FirebaseStorage.instance.ref().child(widget.item!.picLocation ?? "");

        print(widget.item!.picLocation);
        try {
          await ref.getDownloadURL().then((value) =>
              setState(() {
                url = value;

                //url = 'https://${url!}';
              }));
        } on FirebaseStorage catch (e) {
          print('Did not get URL: ${e}');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    setUp();

    print("url: ${widget.item}");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: null,
        builder: (BuildContext context, AsyncSnapshot text) {
      return Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              !widget.customPic ?

              Container(
                height: MediaQuery.of(context).size.height/widget.containerLength,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius:
                    !widget.withBorder ?
                        const BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)):
      const BorderRadius.only(bottomRight: Radius.circular(0), bottomLeft: Radius.circular(0)),
                    image:
                    DecorationImage(
                        image:  AssetImage(widget.picLocation),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(.0), BlendMode.darken)
                    )
                ),
              ):

                  //else if
              Container(
                height: MediaQuery.of(context).size.height/widget.containerLength,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius:
                    !widget.withBorder ?
                    const BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)):
                    const BorderRadius.only(bottomRight: Radius.circular(0), bottomLeft: Radius.circular(0)),
                ),
                child:
                url != null
                ? Image.network(
                url.toString(),
                fit: BoxFit.fill,
                )
                    : Image.asset('lib/Images/under-construction-2629947_1920.jpg',fit: BoxFit.fill,)),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    widget.withTitle ?? true ?
                    StrokeText(text: widget.headerName,
                      textStyle: const TextStyle(
                          fontSize: 48,
                          color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      strokeColor: Theme.of(context).colorScheme.primary,
                      strokeWidth: 3,
                    ):const SizedBox(),

                    StrokeText(text: '* Gluten Free',
                      textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.black
                      ),
                      strokeColor: Theme.of(context).colorScheme.secondary,
                      strokeWidth: 3,
                    ),
                  ],
                ),
              ),


            ],
          ),

          widget.withBorder ?
          Image.asset('lib/Images/IMG-3125.jpg'): const SizedBox()
        ],
      );
  }
    );
  }
}