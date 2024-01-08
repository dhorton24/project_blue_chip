


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_blue_chip/Custom%20Data/FoodOptions.dart';
import 'package:uuid/uuid.dart';

import '../Custom Data/Item.dart';

class ItemFirebase{
  List<Item> itemCatalog = [];

  Future<List<Item>> getItemCatalog() async {
    itemCatalog.clear();

    final docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) => item.toFireStore());

    await docRef.get().then((value) => {
      for (var docSnapshot in value.docs)
        {itemCatalog.add(docSnapshot.data())}
    });

    return itemCatalog;
  }

  Future addItemToCatalog(Item item, String? path,List<String> optionsNameList, List<num> optionsPriceList) async{
    var uuid = Uuid();
    item.itemID = uuid.v4();

    //if it has a picture, upload to storage
    if (path != null) {
      uploadPic(path, item); //created function to upload pic to database
      item.picLocation =
      'NachoMomma/images/itemCatalog/itemCatalog${item.itemID}.jpg'; //store path to database in variable to reference later
    }

    //create ref for catalog
    final docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) => item.toFireStore());

    //store item
    docRef.set(item).whenComplete(() => addOptionToItem(item, optionsNameList, optionsPriceList)
    );
  }


  Future editItemInCatalog(Item item, String? path)async{



    if (path != null) {
      uploadPic(path, item); //created function to upload pic to database
      item.picLocation =
      'NachoMomma/images/itemCatalog/itemCatalog${item.itemID}.jpg'; //store path to database in variable to reference later
    }

    final docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) => item.toFireStore());


    docRef.update({'itemName':item.itemName});
    docRef.update({'retail':item.retail});
    docRef.update({'itemDescription':item.itemDescription});
    docRef.update({'onSale':item.onSale});

    if(item.salePrice !=null) {
      docRef.update({'salePrice':item.salePrice});
    }
    if(item.picLocation != null) {
      docRef.update({'picLocation':item.picLocation});
    }

    docRef.update({'category':item.category});

  }

  deleteItemInCatalog(Item item){
    final docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .withConverter(
        fromFirestore: Item.fromFireStore,
        toFirestore: (Item item, options) => item.toFireStore());

    docRef.delete();

  }

  uploadPic(String path, Item item) async {
    final storageRef = FirebaseStorage.instance.ref();

    final refString =
        'NachoMomma/images/itemCatalog/itemCatalog${item.itemID}.jpg';

    final imageRef = storageRef.child(refString);


    File file = File(path);

    try {
      await imageRef.putFile(file);
    } on FirebaseException catch (e) {
      print("Picture Error: $e");
    }
  }

  Future<String> downloadPic(Item item) async {
    final storageRef = FirebaseStorage.instance.ref();

    if (item.picLocation != null) {
      final pathReference = storageRef.child(item.picLocation!);
      final imageUrl = await pathReference.getDownloadURL();
      return imageUrl;
    }

    return '';
  }


  addOptionToItem(Item item,List<String> optionsNameList, List<num> optionsPriceList ){



    for(final (index,optionsName) in optionsNameList.indexed){
      var uuid = Uuid();
      var id = uuid.v4();

      late FoodOptions foodOptions;

      try{
         foodOptions = FoodOptions(id: id, optionName: optionsName, price:optionsPriceList[index] );
      }catch (error){
        print(error);
         foodOptions = FoodOptions(id: id, optionName: optionsName, price:1.00 );

      }

      //reference to option
      var docRef = FirebaseFirestore.instance
          .collection('itemCatalog')
          .doc(item.itemID)
          .collection('options')
          .doc(id)
          .withConverter(
          fromFirestore: FoodOptions.fromFireStore,
          toFirestore: (FoodOptions item, options) => item.toFireStore());


      docRef.set(foodOptions);
    }

  }

  Future addSingleOptionToItem(Item item, String optionName, num price)async{

    var uuid = Uuid();
    var id = uuid.v4();

    FoodOptions foodOptions = FoodOptions(id: id, optionName: optionName, price: price);

    //reference to option
    var docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .collection('options')
        .doc(id)
        .withConverter(
        fromFirestore: FoodOptions.fromFireStore,
        toFirestore: (FoodOptions item, options) => item.toFireStore());


    docRef.set(foodOptions);
  }


  Future editOption(Item item, FoodOptions foodOptions)async {
    //reference to option
    var docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .collection('options')
        .doc(foodOptions.id)
        .withConverter(
        fromFirestore: FoodOptions.fromFireStore,
        toFirestore: (FoodOptions item, options) => item.toFireStore());

    docRef.update({'optionName':foodOptions.optionName});
    docRef.update({'price':foodOptions.price});
  }

  Future deleteOption(Item item,FoodOptions foodOptions) async{

    var docRef = FirebaseFirestore.instance
        .collection('itemCatalog')
        .doc(item.itemID)
        .collection('options')
        .doc(foodOptions.id)
        .withConverter(
        fromFirestore: FoodOptions.fromFireStore,
        toFirestore: (FoodOptions item, options) => item.toFireStore());


    await docRef.delete();

  }

Future deleteItem(Item item)async{
  final docRef = FirebaseFirestore.instance
      .collection('itemCatalog')
      .doc(item.itemID)
      .withConverter(
      fromFirestore: Item.fromFireStore,
      toFirestore: (Item item, options) => item.toFireStore());

  docRef.delete();
}

}