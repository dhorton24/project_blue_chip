

import 'package:cloud_firestore/cloud_firestore.dart';

class Item{

  String itemName;  //item name
  double retail;    //retail of item
  String itemID;    //item Id to reference in database
  String itemDescription;   //item description

  bool onSale;    //if item is on sale
  double? salePrice;  //sale price if on sale

  String? picLocation;  //location of picture of database if uploaded
  int? amountInCart;    //amount of item in cart... this is specific to user.

  //database to contain 'ingredients' collection
 String category;

  num? servingSize;   //serving size denoted by max amount. ex. -> 20,40,60...


Item({required this.itemName, required this.retail, required this.itemID, required this.itemDescription,
required this.onSale,  this.salePrice, this.picLocation, this.amountInCart, required this.category, this.servingSize});


  factory Item.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options){
    final data = snapshot.data();
    return Item(itemName: data?['itemName'],
        retail: data?['retail'],
        itemID: data?['itemID'],
        itemDescription: data?['itemDescription'],

        onSale: data?['onSale'],
       servingSize: data?['servingSize'],
        picLocation: data?['picLocation'],
        salePrice: data?['salePrice'],
        amountInCart: data?['amountInCart'],
    category: data?['category']);
  }

  Map<String, dynamic> toFireStore(){
    return{
      'itemName':itemName,
      'retail':retail,
      'itemID':itemID,
      'itemDescription': itemDescription,
      'onSale': onSale,

      'picLocation': picLocation,
      'salePrice':salePrice,
      'amountInCart':amountInCart,
      'servingSize':servingSize,
      'category':category
    };
  }



}