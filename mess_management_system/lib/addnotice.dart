import 'package:ex2app/dbhelper/constant.dart';
import 'package:ex2app/dbhelper/login.dart';
import 'package:ex2app/notice.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class AddNotice extends StatefulWidget{
     State<AddNotice> createState() =>_AddNotice();
}

class _AddNotice extends State<AddNotice> {
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController textController = TextEditingController();


  void insertData() async {
    
    final String name = nameController.text;
    final String date = dateController .text;
    final String text = textController.text;
    var db,userCollection;
    db = await M.Db.create(url);
    await db.open();
    //inspect(db);
    userCollection = db.collection(NOTICE);
    Map<String, dynamic> userMap = {
    'name': name,
    'date': date,
    'description': text,
  };

  // Convert Map to JSON string
  //String jsonString = jsonEncode(userMap);

    try{
        var result = await userCollection.insert(userMap);
        if(result.isSuccess){
          print('data inserted');
        }
        else{
            print('something error');
        }
      }catch(e){
        print(e.toString());
  }
  
    

    await db.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice Add'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date',
              ),
              
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Notice',
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                insertData();
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoticePage()),
              );
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
  
}