import 'package:ex2app/Manager/managerprofile.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:ex2app/dbhelper/constant.dart';


class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  final TextEditingController passwordController = TextEditingController();
  String matchResult = '';

  Future<bool> matchData() async {
    final String password = passwordController.text;

    var db, userCollection;
    db = await M.Db.create(url);
    await db.open();
    userCollection = db.collection(MANAGER);

    final document = await userCollection.findOne(M.where.eq('password', password));

    if (document != null) {
      setState(() {
        matchResult = 'Data matched successfully!';
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
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                Future<bool> isMatched = matchData();
                if (await isMatched == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagerProfile(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Incorrect login data. Please try again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
