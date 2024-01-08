import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:list_picker/list_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_blue_chip/Screens/Food%20Menu/AdminMenu/EditOptions.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../Custom Data/Item.dart';
import '../../../Firebase/itemFirebase.dart';
import '../../../Widgets/TextFields.dart';



class EditItemScreen extends StatefulWidget {
  final Item item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {


  TextEditingController itemNameController = TextEditingController();
  TextEditingController retailController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();

  TextEditingController salePriceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  TextEditingController option1Name = TextEditingController();
  TextEditingController option1Price = TextEditingController();

  TextEditingController option2Name = TextEditingController();
  TextEditingController option2Price = TextEditingController();

  TextEditingController option3Name = TextEditingController();
  TextEditingController option3Price = TextEditingController();

  TextEditingController option4Name = TextEditingController();
  TextEditingController option4Price = TextEditingController();

  bool onSale = false;  //control if item is on sale or not. If on sale, text field will be shown
  bool showOptions = false; //controls to show add on options for item. If true, it will show text fields

  ItemFirebase itemFirebase = ItemFirebase();

  File? imageFile;

  Future getImage() async {
    PermissionStatus result;

    final ImagePicker picker = ImagePicker();

    if (Platform.isAndroid) {
      print("Is android");
      result = await Permission.photos.request();
      print("Status: $result");

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

    setState(() {
      itemNameController.text = widget.item.itemName;
      retailController.text = widget.item.retail.toString();
      itemDescriptionController.text = widget.item.itemDescription;

      salePriceController.text = widget.item.salePrice.toString();
      categoryController.text = widget.item.category;

      onSale = widget.item.onSale;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: StrokeText(
          text: 'Edit Item',
          textStyle: TextStyle(
            fontSize: 28,
            color: Theme
                .of(context)
                .colorScheme
                .secondary,
            fontWeight: FontWeight.bold,
          ),
          strokeColor: Theme
              .of(context)
              .colorScheme
              .primary,
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

      body: SingleChildScrollView(
        child: Column(

          children: [
            Center(child: Text("Editing: ${widget.item.itemName}",style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),

            textFields(context),

          ],
        ),
      ),
    );
  }

  Widget textFields(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        showDialog(context: context, builder: (context)=>AlertDialog(
                          title:  Text("Delete ${widget.item.itemName}? This can not be undone.",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),textAlign: TextAlign.center,),
                          actions: [
                            ElevatedButton(onPressed: (){

                              itemFirebase.deleteItem(widget.item).whenComplete(() => {
                                Navigator.pop(context),
                              Navigator.pop(context)
                              });
                            }, child: const Text("Delete")),
                            ElevatedButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: const Text("Cancel"))
                          ],
                        ));
                      }, icon: const Icon(Icons.delete_outline)),
                      Row(
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
                              value: widget.item.onSale,
                              onChanged: (value) => {
                                setState(() {
                                  onSale = value;
                                  widget.item.onSale = value;
                                })
                              })
                        ],
                      )

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

                  ElevatedButton(onPressed: (){   //toggle show options
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditOptions(item: widget.item)));
                  }, child: const Text("Edit/Add options")),



                  ElevatedButton(
                      onPressed: () {
                        getImage();
                      },
                      child: const Text("Upload Picture")),
                  if (widget.item.picLocation != null && imageFile != null)
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

                                  //assign controllers to variables
                                  setState(() {
                                    widget.item.itemName = itemNameController.text;

                                    //to avoid error
                                    if(retailController.text.isNotEmpty) {
                                      widget. item.retail =
                                          double.parse(
                                              retailController.text);
                                    }
                                    widget. item.itemDescription =
                                        itemDescriptionController.text;

                                    widget. item.onSale = onSale;
                                    if (onSale) {
                                      if(salePriceController.text == 'null'){
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fill out sale price")));

                                      }
                                     else if(salePriceController.text.isNotEmpty){

                                       //if sale price entered is badly formatted
                                      try{
                                        widget. item.salePrice = double.parse(
                                            salePriceController.text);

                                      }catch (e){
                                        widget.item.salePrice = 10.00;
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sale Price badly formatted. Temporary price given. Please edit again.")));
                                      }


                                      }

                                    }

                                    widget. item.category = categoryController.text;
                                  });

                                  //show errors
                                  if(itemNameController.text.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter food name")));
                                  }else if(retailController.text.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter retail")));
                                  }else if(itemDescriptionController.text.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter food description")));
                                  }
                                  else if(onSale == true && salePriceController.text.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter food name")));

                                  }
                                  else{
                                    itemFirebase.editItemInCatalog(widget.item, imageFile != null
                                        ? imageFile!.path
                                        : null).whenComplete(() =>
                                       { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Update Complete"))),
                                       Navigator.pop(context)}
                                    );
                                  }


                                },
                                child: const Text('Submit'))),
                      ],
                    ),
                  )
                ],
              ),
        ),
      ),
    );
  }
}
