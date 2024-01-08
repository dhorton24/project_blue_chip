import 'package:cloud_firestore/cloud_firestore.dart';

class FoodOptions{

  String id;
  String optionName;
  num price;


  FoodOptions({required this.id,
  required this.optionName,
  required this.price});

  factory FoodOptions.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return FoodOptions(id: data?['id'], optionName: data?['optionName'], price: data?['price']);
  }

  Map<String, dynamic> toFireStore() {
    return {
     'id':id,
      'optionName':optionName,
      'price':price
    };
  }
}