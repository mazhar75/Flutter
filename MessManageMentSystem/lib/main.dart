import 'dart:convert';
import 'dart:developer';

import 'package:ex2app/dbhelper/constant.dart';
import 'package:ex2app/Main/login.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter/rendering.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:flutter_native_splash/flutter_native_splash.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor:Colors.grey[900],
      appBar: AppBar(
        title: Text('Mess System'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation : 0.0,
      ),
      body: Center(
         child: Image(
         image: AssetImage('assets/londonicottege.jpg'),
       ),
      ),
       floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: Text("btn1"),
            onPressed: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterPage()),
              );
            },
            tooltip: 'Register',
            child:Text('Register'),
            backgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
               ),
            ),
            
            SizedBox(height: 16.0),
        FloatingActionButton(
            heroTag: Text("btn2"),
            onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
          },
        tooltip: 'Login',
        child: Text('Login'),
        backgroundColor: Colors.grey,
         shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
         ),
        ),   
         
         
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String matchResult = '';
 Future<bool> matchData() async {
  final String name = nameController.text;
  final String email = emailController.text;
  final String password = passwordController.text;

  var db, userCollection;
  db = await M.Db.create(url);
  await db.open();
  //inspect(db);
  userCollection = db.collection(REG);

  final document = await userCollection.findOne(M.where
      .eq('name', name)
      .eq('email', email)
      .eq('password', password));

  if (document != null) {
    setState(() {
      matchResult = 'Data matched successfully!';
      print(matchResult);
    });

    await db.close();
    // Return true after closing the database
    return true;
  } else {
    setState(() {
      matchResult = 'Data not found!';
      print(matchResult);
    });

    await db.close();
    // Return false after closing the database
    return false;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login window'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Mess Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                Future<bool> isMatched = matchData();
                if(await isMatched==true){
                 // ignore: use_build_context_synchronously
                 Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => ProfilePage( data: nameController.text)),
                  );
                }
                else{
                   // here show a msg that ur data was wrong,which show up in login page

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

class RegisterPage extends StatefulWidget{
     State<RegisterPage> createState() =>_register();
}

class _register extends State<RegisterPage> {
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  void insertData() async {
    
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    var db,userCollection;
    db = await M.Db.create(url);
    await db.open();
    //inspect(db);
    userCollection = db.collection(REG);
    var id=M.ObjectId();
    Map<String, dynamic> userMap = {
    'id': id,
    'name': name,
    'email': email,
    'password': password,
  };

  // Convert Map to JSON string
  //String jsonString = jsonEncode(userMap);

    try{
        var result = await userCollection.insert(userMap);
        if(result.isSuccess){
          print('Registration Successful');
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
        title: Text('Registration Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                    'This app initially Only for londoni cottege.In future it may be lounched after some update',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
            ),
            Text(
                    'Mess Name: Londoni Cottege',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
                    'Gmail:test@gmail.com',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
                    'Password: Sorry ! This is credential information.Only mess member know',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            ElevatedButton(
              onPressed: () async {
                insertData();
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              },
              child: Text('Login Window'),
            ),
          ],
        ),
      ),
    );
  }
  
}
