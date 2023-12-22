

import 'Item.dart';

class TestData{

  List<Item> itemList = [

    Item(itemName: 'Fajitas Chicken or Steak', retail: 10.00, itemID: 'eraghrheah', itemDescription: 'Served with corn tortilla, mixed sauteed onion and peppers. And white cheese dip and chips', onSale: false,picLocation: 'lib/Images/IMG-3122.jpg', category: 'Nachos'),
    Item(itemName: 'The Wonder Boy', retail: 8.99, itemID: 'ahgah', itemDescription: 'A Mix of toppings to go along with crinkle cut fires', onSale: false,picLocation: 'lib/Images/IMG-3126.jpg',category: 'Misc')


  ];


  List<String> categoryName = ["Nachos",'Enchiladas','Pasta','Misc.'];
  List<String> categoryPicLocation= ['lib/Images/food-576351_1920.png','lib/Images/taco-576390_1920.png','lib/Images/pasta-576417_1920.png','lib/Images/vegetables-155616_1920.png'];
}