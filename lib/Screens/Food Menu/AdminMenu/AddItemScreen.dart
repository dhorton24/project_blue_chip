import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_blue_chip/Firebase/itemFirebase.dart';
import 'package:project_blue_chip/Widgets/TextFields.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:list_picker/list_picker.dart';

import '../../../Custom Data/Item.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController retailController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();

  TextEditingController salePriceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  bool onSale = false;

  ItemFirebase itemFirebase = ItemFirebase();

  Item item = Item(
      itemName: '',
      retail: 1.00,
      itemID: '',
      itemDescription: '',
      onSale: false,
      category: 'Nacho');

  File? imageFile;

  Future getImage() async {
    PermissionStatus result;

    final ImagePicker picker = ImagePicker();

    if (Platform.isAndroid) {
      print("Is android");
      result = await Permission.photos.request();
      print("Status: ${result}");

      if (result.isGranted) {
        try {
          final XFile? media = await picker.pickMedia();

          if (media != null) {
            setState(() {
              imageFile = File(media.path);
            });
          }
        } catch (err) {
          print("Image Error $err");
        }
      } else if (result.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      try {
        final XFile? media = await picker.pickMedia();

        if (media != null) {
          setState(() {
            imageFile = File(media.path);
          });
        }
      } catch (err) {
        print("Image Error $err");
      }
    }
  }

  @override
  void initState(){
    super.initState();

    categoryController.text = 'Nachos';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            )),
        title: StrokeText(
          text: 'Add Item',
          textStyle: TextStyle(
            fontSize: 32,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
          strokeColor: Theme.of(context).colorScheme.primary,
          strokeWidth: 3,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Sale?",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 26),
                        ),
                        Switch(
                            value: onSale,
                            onChanged: (value) => {
                                  setState(() {
                                    onSale = value;
                                  })
                                })
                      ],
                    ),
                    TextFields(
                        text: 'Enter food name (Required)',
                        textEditingController: itemNameController,
                        textInputType: TextInputType.text),
                    TextFields(
                        text: 'Enter retail (Required)',
                        textEditingController: retailController,
                        textInputType: const TextInputType.numberWithOptions(
                            decimal: true)),
                    TextFields(
                        text: 'Enter item description (Required)',
                        textEditingController: itemDescriptionController,
                        textInputType: TextInputType.text),
                    onSale
                        ? TextFields(
                            text: 'Enter sale price',
                            textEditingController: salePriceController,
                            textInputType: TextInputType.number)
                        : const SizedBox(),
                    ListPickerField(
                        controller: categoryController,
                       // initialValue: 'Nachos',
                        label: 'Select category',
                        items: const [
                          'Nachos',
                          'Pasta',
                          'Enchiladas',
                          'Misc.'
                        ]),
                    ElevatedButton(
                        onPressed: () {
                          getImage();
                        },
                        child: const Text("Upload Picture")),
                    if (imageFile != null)
                      ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.file(
                            imageFile!,
                            height: 100,
                            width: 125,
                            fit: BoxFit.fill,
                          ))
                    else
                      const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      item.itemName = itemNameController.text;
                                      item.retail =
                                          double.parse(retailController.text);
                                      item.itemDescription =
                                          itemDescriptionController.text;

                                      item.onSale = onSale;
                                      if (onSale) {
                                        item.salePrice = double.parse(
                                            salePriceController.text);
                                      }

                                      item.category = categoryController.text;
                                    });

                                    await itemFirebase
                                        .addItemToCatalog(
                                            item,
                                            imageFile != null
                                                ? imageFile!.path
                                                : null)
                                        .whenComplete(() =>{

                                          Navigator.pop(context),

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text("Success")))});
                                  },
                                  child: const Text('Submit'))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
