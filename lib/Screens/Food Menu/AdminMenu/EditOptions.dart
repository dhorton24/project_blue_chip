import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_blue_chip/Firebase/itemFirebase.dart';
import 'package:project_blue_chip/Widgets/TextFields.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../Custom Data/FoodOptions.dart';
import '../../../Custom Data/Item.dart';



class EditOptions extends StatefulWidget {
  Item item;

  EditOptions({required this.item});


  @override
  State<EditOptions> createState() => _EditOptionsState();
}

class _EditOptionsState extends State<EditOptions> {


  late Stream<QuerySnapshot> optionsStream;
  List<DocumentSnapshot> optionsList = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  ItemFirebase itemFirebase = ItemFirebase();


  startStream() async {
    optionsStream = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(widget.item.itemID)
        .collection('options')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: startStream(),
        builder: (BuildContext context, AsyncSnapshot text) {
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
            text: 'Options',
            textStyle: TextStyle(
              fontSize: 32,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
            strokeColor: Theme.of(context).colorScheme.primary,
            strokeWidth: 3,
          ),
          
          actions: [
            IconButton(onPressed: (){
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Add an option for ${widget.item.itemName}",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),textAlign: TextAlign.center,),

                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFields(text: 'Edit name', textEditingController: nameController, textInputType: TextInputType.text),
                      TextFields(text: 'Edit price', textEditingController: priceController, textInputType: const TextInputType.numberWithOptions(decimal: true)),

                      ElevatedButton(onPressed: (){
                        itemFirebase.addSingleOptionToItem(widget.item, nameController.text, double.parse(priceController.text)).whenComplete(() => {
                          nameController.clear(),
                          priceController.clear(),

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Option added!"))),
                          
                          Navigator.pop(context)
                        });
                        }, child: Text("Submit"))
                    ],
                  ),
                );
              });
            }, icon: Icon(Icons.add,color: Colors.white,))
          ],
        ),


        body: Column(
          children: [
            Text("Options for ${widget.item.itemName}",style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.secondary,fontWeight: FontWeight.bold),),
            Expanded(
              child: StreamBuilder(
                stream: optionsStream,
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
                  optionsList = snapshot.data!.docs;

                  if (optionsList.isEmpty) {
                    return Center(
                        child: Text(
                          'No add on options...',
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
                        FoodOptions thisOptions = FoodOptions(
                            id: optionsList[index]['id'],
                            optionName: optionsList[index]['optionName'],
                            price: optionsList[index]['price']);

                        return OptionsCell(thisOptions: thisOptions, item: widget.item,);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox();
                      },
                      itemCount: optionsList.length);
                },
              ),
            )
          ],
        ),
      );
  }
    );
  }
}

class OptionsCell extends StatefulWidget {
   OptionsCell({
    super.key,
    required this.thisOptions,
     required this.item
  });

   FoodOptions thisOptions;
   final Item item;


  @override
  State<OptionsCell> createState() => _OptionsCellState();
}

class _OptionsCellState extends State<OptionsCell> {

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  ItemFirebase itemFirebase = ItemFirebase();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.thisOptions.optionName,style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold),),
                    Text("\$${widget.thisOptions.price.toStringAsFixed(2)}",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),

                  ],
                ),
                IconButton(onPressed: (){
                  showDialog(context: context, builder: (context)=> AlertDialog(
                    title: Text('Edit ${widget.thisOptions.optionName}'),
                    actions: [
                      TextFields(text: 'Edit name', textEditingController: nameController, textInputType: TextInputType.text),
                      TextFields(text: 'Edit price', textEditingController: priceController, textInputType: const TextInputType.numberWithOptions(decimal: true)),
                      
                      ElevatedButton(onPressed: () async {

                        if(nameController.text.isNotEmpty){
                          setState(() {
                            widget.thisOptions.optionName = nameController.text;
                          });
                        }
                        if(priceController.text.isNotEmpty){
                          setState(() {
                            widget.thisOptions.price = num.parse(priceController.text);
                          });
                        }

                       await itemFirebase.editOption(widget.item, widget.thisOptions).whenComplete(() => Navigator.pop(context)
                       );

                      }, child: const Text("Submit")),

                      ElevatedButton(onPressed: (){
                        itemFirebase.deleteOption(widget.item, widget.thisOptions).whenComplete(() => {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Option removed"))),
                          Navigator.pop(context)
                        });
                      }, child: const Text("Delete Option"))

                    ],
                  ));
                }, icon: const Icon(Icons.more_horiz_outlined))
              ],
            ),
          )),
    );
  }
}
