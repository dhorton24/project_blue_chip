import 'package:flutter/material.dart';





class TextButtons extends StatelessWidget {


  final IconData iconData;
  final String text;
  Function function;


    TextButtons({
    super.key,
    required this.iconData,
    required this.text,
     required this.function
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(iconData,color: Theme.of(context).colorScheme.primary,),
              Text(text,style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.primary,fontSize: 18),),
            ],
          ),

          IconButton(onPressed: (){
            function();
            }, icon: const Icon(Icons.arrow_forward_ios_outlined))
        ],
      ),
    );
  }
}