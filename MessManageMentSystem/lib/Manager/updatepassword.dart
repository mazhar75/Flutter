import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:ex2app/dbhelper/constant.dart';


class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage > {
  final TextEditingController oldpasswordController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  String matchResult = '';

  Future<bool> matchData() async {
    final String oldpassword = oldpasswordController.text;
     final String newpassword = newpasswordController.text;

    var db, userCollection;
    db = await M.Db.create(url);
    await db.open();
    userCollection = db.collection(MANAGER);

    final document = await userCollection.findOne(M.where.eq('password', oldpassword));

    if (document != null) {
      // Get the document ID
      var documentId = document['_id'];

      // Use the update method to update the password
      await userCollection.update(
        M.where.id(documentId),
        M.modify.set('password', newpassword),
      );

      setState(() {
        matchResult = 'Password updated successfully!';
        print(matchResult);
      });

      await db.close();
      return true;
    } else {
      setState(() {
        matchResult = 'Data not found!';
        print(matchResult);
      });

      await db.close();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Login window'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: oldpasswordController,
              decoration: InputDecoration(
                labelText: 'Old Password',
              )
            ),
            SizedBox(height: 24.0),
            TextField(
              controller: newpasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                Future<bool> isMatched = matchData();
                if (await isMatched == true) {
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password updated.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incorrect old password. Please try again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
