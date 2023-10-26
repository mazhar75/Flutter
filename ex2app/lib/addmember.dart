import 'dart:convert';
import 'dart:developer';

import 'package:ex2app/dbhelper/constant.dart';
import 'package:ex2app/dbhelper/login.dart';
import 'package:ex2app/dbhelper/mongodb.dart';
import 'package:ex2app/managerprofile.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter/rendering.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:flutter_native_splash/flutter_native_splash.dart';


class AddMember extends StatefulWidget {

  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  List<TextEditingController> controllers = [];

  void insertData() async {
    
    var db,userCollection;
    db = await M.Db.create(url);
    await db.open();
    //inspect(db);
    userCollection = db.collection(MEMBER);
    //var id=M.ObjectId();
    for (var controller in controllers) {
    String name=controller.text;
    Map<String, dynamic> userMap = {
    'name': name,
    };
    try{
        var result = await userCollection.insert(userMap);
        if(result.isSuccess){
        }
        else{
            print('something error');
        }
      }catch(e){
        print(e.toString());
  }
}
   await db.close();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Add Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controllers.length,
                itemBuilder: (context, index) {
                  return TextFormField(
                    controller: controllers[index],
                    decoration: InputDecoration(
                      labelText: 'Member ${index + 1} name',
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton( 
              onPressed: () {
                // Add a new TextEditingController when the button is pressed
                setState(() {
                  controllers.add(TextEditingController());
                });
              },
              child: Text('Add another'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
               insertData();
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManagerProfile ()),
              );
                
              },
              child: Text('Add All'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all the controllers to avoid memory leaks
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}