import 'package:flutter/material.dart';





class TextButtons extends StatelessWidget {


  final IconData iconData;
  final String text;

   const TextButtons({
    super.key,
    required this.iconData,
    required this.text
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
              Icon(iconData,color: Theme.of(context).colorScheme.secondary,),
              Text(text,style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.secondary,fontSize: 18),),
            ],
          ),

          IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios_outlined))
        ],
      ),
    );
  }
}