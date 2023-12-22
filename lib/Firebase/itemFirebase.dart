


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  Future addItemToCatalog(Item item, String? path) async{
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
    docRef.set(item);
  }


  editItemInCatalog(Item item, String? path){



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


    docRef.set(item);
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


}