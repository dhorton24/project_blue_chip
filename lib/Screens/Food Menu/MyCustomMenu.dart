import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_blue_chip/Firebase/BookingEventsFirebase.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../Custom Data/Item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';

import '../../Custom Data/Users.dart';



class CheckOut extends StatefulWidget {

  final Users users;

  const CheckOut({super.key, required this.users});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {


  num totalServingSize =0 ;
  num cartTotal = 0 ;

  Map<String, dynamic>? paymentIntent;

  late Stream<QuerySnapshot> cartStream;
  List<DocumentSnapshot> cartList = [];
  BookingEventsFirebase bookingEventsFirebase = BookingEventsFirebase();


  setUp() async {
    cartStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.users.id)
    .collection('menu')
        .snapshots();

    bookingEventsFirebase.getTotalServingSize(widget.users);
    bookingEventsFirebase.getMenuTotal(widget.users);

  }


  @override
  void initState(){
    super.initState();

    if(mounted) {
      DocumentReference reference = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.users.id);
      reference.snapshots().listen((querySnapshot) {
        setState(() {
          totalServingSize = querySnapshot.get('totalServingSize');
          if(querySnapshot.get('cartTotal')!= null){
            cartTotal = querySnapshot.get('cartTotal');
          }

        });
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setUp(),
        builder: (BuildContext context, AsyncSnapshot text) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: StrokeText(
              text: 'Custom Food Menu',
              textStyle: TextStyle(
                fontSize: 22,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
              strokeColor: Theme.of(context).colorScheme.primary,
              strokeWidth: 3,
            ),
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // SizedBox(
            //   height: MediaQuery.of(context).size.height/2.2,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: StreamBuilder(
            //       stream: cartStream,
            //       builder: (BuildContext context,
            //           AsyncSnapshot<QuerySnapshot> snapshot) {
            //         //if there is an error
            //         if (snapshot.hasError) {
            //           return const Text('Error');
            //         }
            //         //while it connects
            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return const CircularProgressIndicator();
            //         }
            //         cartList = snapshot.data!.docs;
            //
            //         if (cartList.isEmpty) {
            //           return Center(
            //               child: Text(
            //                 'Empty Menu.',
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .bodyMedium!
            //                     .copyWith(
            //                     color: Theme.of(context).colorScheme.primary),
            //                 textAlign: TextAlign.center,
            //               ));
            //         }
            //
            //         return ListView.separated(
            //           scrollDirection: Axis.horizontal
            //             ,
            //             //padding: EdgeInsets.zero,
            //             itemBuilder: (BuildContext context, int index) {
            //               Item thisItem = Item(
            //                   itemName: cartList[index]['itemName'],
            //                   retail: cartList[index]['retail'],
            //                   itemID: cartList[index]['itemID'],
            //                   itemDescription: cartList[index]
            //                   ['itemDescription'],
            //                   onSale: cartList[index]['onSale'],
            //                   picLocation: cartList[index]['picLocation'],
            //                   amountInCart: cartList[index]['amountInCart'],
            //                   salePrice: cartList[index]['salePrice'],
            //                   category: cartList[index]['category'],
            //               servingSize: cartList[index]['servingSize']);
            //
            //               return GestureDetector(
            //                   onTap: () {
            //
            //                   },
            //                   child: CartItemTile(item: thisItem,users:  widget.users,));
            //             },
            //             separatorBuilder: (BuildContext context, int index) {
            //               return const SizedBox();
            //             },
            //             itemCount: cartList.length);
            //       },
            //     ),
            //   ),
            // ).animate().fadeIn(delay: Duration(milliseconds: 350)),

            StrokeText(
              text: 'My Event',
              textStyle: TextStyle(
                fontSize: 30,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).colorScheme.primary,
                decorationThickness: 1.6
              ),
              strokeColor: Theme.of(context).colorScheme.primary,
              strokeWidth: 3,
            ),


            menuInfo().animate().flip(),

            SafeArea(child: payButtons())
          ],
        ),
      );
  }
    );
  }

  Widget payButtons() {
    return Row(
      mainAxisSize:MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(7)))),
                    onPressed: () {

                        makePayment(50.00);
                    },
                    child: Text(
                      "Pay Deposit \$50.00",
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    )),
              ),
            ),

          ],
        );
  }

  Column menuInfo() {
    return Column(
          children: [

            Text("Total Serving Size: $totalServingSize",style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor)),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Total due today: \$${(cartTotal *.15).toStringAsFixed(2)} (15% of total payment)",style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            )
          ],
        );
  }



  Future<void> makePayment(num total) async {

    print("${dotenv.env['STRIPE_SECRET']}");

    var newTotal = total.toStringAsFixed(2).toString().replaceAll('.', '');
    try {
      //payment intent
      paymentIntent = await createPaymentIntent(newTotal, 'USD');

      //initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            style: ThemeMode.light,
            merchantDisplayName: 'Nacho Momma\'s',

        ),
      );

      //display payment sheet
      displayPaymentSheet();
    } catch (error) {
     print("Here: ${error}");
    }


  }

  createPaymentIntent(String amount, String currency) async {



    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };



      //make post request to stripe
      var response =
      await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body);
      print("${json.decode(response.body)}");
      return json.decode(response.body);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  displayPaymentSheet()async{
    try{
      await Stripe.instance.presentPaymentSheet().then((value) => {




        ///TODO create new method to empty event from user in database
        bookingEventsFirebase.clearShoppingCart(widget.users).whenComplete(() => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
            content: Text(
                "Successfully paid"))))


      }).onError((error, stackTrace) => {throw Exception(error)});
    }catch (error){

    }  StripeException (error){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
          content: Text(
              "Error processing payment")));
    }
  }
}

class CartItemTile extends StatefulWidget {
  final Item item;
  final Users users;


  const CartItemTile({super.key, required this.item, required this.users});

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {


  BookingEventsFirebase bookingEventsFirebase = BookingEventsFirebase();

  String? url;
  num totalServingSize = 0;

  setUp() async {
    if (widget.item.picLocation != null && widget.item.picLocation != 'null') {
      var ref =  FirebaseStorage.instance
          .ref()
          .child(widget.item.picLocation ?? "");

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
  void initState(){
    super.initState();

    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: null,
        builder: (BuildContext context, AsyncSnapshot text) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 200,
          width: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary,
              blurRadius: 3,
              spreadRadius: 3
            )
          ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 150,
                    height: 150,child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                    child:    url != null ?
                    Image.network(
                      url.toString(),
                      fit: BoxFit.fill,
                    ):
                    const CircularProgressIndicator())),
              ),

              Flexible(child: Text(widget.item.itemName,style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.primary),textAlign: TextAlign.center,)),


              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Theme.of(context).colorScheme.primary)
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        widget.item.servingSize! <=20 ?
                        IconButton(onPressed: (){
                         setState(() {

                         });

                         bookingEventsFirebase.deleteItemFromMenu(widget.users, widget.item);
                        }, icon: Icon(Icons.delete_outline,color: Theme.of(context).colorScheme.primary,)):
                        IconButton(onPressed: () async {

                          setState(() {
                           widget.item.servingSize= widget.item.servingSize! - 20;
                          });

                          await bookingEventsFirebase.updateServingAmountOnItem(widget.users, widget.item);

                        }, icon: Icon(Icons.remove,color: Theme.of(context).colorScheme.primary,)),


                        VerticalDivider(
                          thickness: 2,
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),

                        Text("${widget.item.servingSize??20}",style: Theme.of(context).textTheme.labelLarge!.copyWith(color:Theme.of(context).colorScheme.primary ),),

                        VerticalDivider(
                          thickness: 2,
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        IconButton(onPressed: () async {
                          setState(() {
                            widget.item.servingSize= widget.item.servingSize! + 20;
                          });

                          await bookingEventsFirebase.updateServingAmountOnItem(widget.users, widget.item);

                        }, icon: Icon(Icons.add_outlined,color: Theme.of(context).colorScheme.primary,)),


                      ],
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(7)))),
                  onPressed: () {
                    bookingEventsFirebase.deleteItemFromMenu(widget.users, widget.item);
                  },
                  child: Text(
                    "Remove from menu",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ))
            ],
          ),
        ),
      );
  }
    );
  }
}
