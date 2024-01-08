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


  TextEditingController option1Name = TextEditingController();
  TextEditingController option1Price = TextEditingController();

  TextEditingController option2Name = TextEditingController();
  TextEditingController option2Price = TextEditingController();

  TextEditingController option3Name = TextEditingController();
  TextEditingController option3Price = TextEditingController();

  TextEditingController option4Name = TextEditingController();
  TextEditingController option4Price = TextEditingController();

  List<String> optionNameList = [];
  List<num> optionPriceList = [];

  bool onSale = false;  //control if item is on sale or not. If on sale, text field will be shown
  bool showOptions = false; //controls to show add on options for item. If true, it will show text fields

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
      body: SingleChildScrollView(
        child: Column(
          children: [

            Text("Add an item to the catalog. Must fill out sections labeled \"required\". Use the \"sale\" toggle switch to have a sale price which will reveal a new text box to input the price. Use the options button to reveal more text boxes for alternate options with this item. ",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary),textAlign: TextAlign.center,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: Colors.white,
                ),
                child:
                Padding(
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
        
                      ElevatedButton(onPressed: (){   //toggle show options
                        setState(() {
                          showOptions = !showOptions;
                        });
        
                      }, child: Text("Add Options")),
        
                      showOptions?
                      Column(
                        children: [
                          TextFields(
                              text: '1 Food options name ...',
                              textEditingController: option1Name,
                              textInputType: TextInputType.text),
                          TextFields(
                              text: '1 Food options price...',
                              textEditingController: option1Price,
                              textInputType: const TextInputType.numberWithOptions(decimal: true)),
                          TextFields(
                              text: '2 Food options name ...',
                              textEditingController: option2Name,
                              textInputType: TextInputType.text),
                          TextFields(
                              text: '2 Food options price...',
                              textEditingController: option2Price,
                              textInputType: const TextInputType.numberWithOptions(decimal: true)),
                          TextFields(
                              text: '3 Food options name ...',
                              textEditingController: option3Name,
                              textInputType: TextInputType.text),
                          TextFields(
                              text: '3 Food options price...',
                              textEditingController: option3Price,
                              textInputType: const TextInputType.numberWithOptions(decimal: true)),
                          TextFields(
                              text: '4 Food options name ...',
                              textEditingController: option4Name,
                              textInputType: TextInputType.text),
                          TextFields(
                              text: '4 Food options price...',
                              textEditingController: option4Price,
                              textInputType: const TextInputType.numberWithOptions(decimal: true)),
                        ],
                      ):
                          const SizedBox(),
        
        
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

                                      //assign controllers to variables
                                      setState(() {
                                        item.itemName = itemNameController.text;

                                        //to avoid error
                                        if(retailController.text.isNotEmpty) {
                                          item.retail =
                                              double.parse(
                                                  retailController.text);
                                        }
                                        item.itemDescription =
                                            itemDescriptionController.text;
        
                                        item.onSale = onSale;
                                        if (onSale) {
                                          item.salePrice = double.parse(
                                              salePriceController.text);
                                        }
        
                                        item.category = categoryController.text;
                                      });

                                      //show errors
                                      if(itemNameController.text.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter food name")));
                                      }else if(retailController.text.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter retail")));
                                      }else if(itemDescriptionController.text.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter food description")));
                                      }else{


                                        await addOptionsToList();

                                        //add item to catalog
                                        await itemFirebase
                                            .addItemToCatalog(
                                            item,
                                            imageFile != null
                                                ? imageFile!.path
                                                : null,
                                        optionNameList,
                                        optionPriceList)
                                            .whenComplete(() =>{

                                          Navigator.pop(context),

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                              content:
                                              Text("Success")))});
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
            )
          ],
        ),
      ),
    );
  }

  Future addOptionsToList()async{
    //go through each controller and add to list if controller is not empty

    try{ if (option1Name.text.isNotEmpty){
      optionNameList.add(option1Name.text);
    }
    if (option2Name.text.isNotEmpty){
      optionNameList.add(option2Name.text);
    }
    if (option3Name.text.isNotEmpty){
      optionNameList.add(option3Name.text);
    } if (option4Name.text.isNotEmpty){
      optionNameList.add(option4Name.text);
    }


    if (option1Price.text.isNotEmpty){
      optionPriceList.add(num.parse(option1Price.text));
    }
    if (option2Price.text.isNotEmpty){
      optionPriceList.add(num.parse(option2Price.text));
    }if (option3Price.text.isNotEmpty){
      optionPriceList.add(num.parse(option3Price.text));
    }
    if (option4Price.text.isNotEmpty){
      optionPriceList.add(num.parse(option4Price.text));
    }
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error!. Make sure everything is correctly formatted and there is a stable internet connection.")));
    }




  }
}
