import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(
    home: Home()
  ));
}
class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context){
     return Scaffold(
         appBar:AppBar(
            title:Text('Assalamualaikum'),
            centerTitle: true,
            backgroundColor: Colors.lightGreen,
         ),
         body:Center(
           child:Image(
            image:AssetImage('assets/nihad.jpg'),
           ),

         ),
         floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child:Text('click'),
            backgroundColor: Colors.black,
         ),
      );
  }
}