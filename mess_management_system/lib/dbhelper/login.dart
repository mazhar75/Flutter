import 'dart:convert';
import 'dart:developer';

import 'package:ex2app/dbhelper/constant.dart';
import 'package:ex2app/dbhelper/mongodb.dart';
import 'package:ex2app/notice.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter/rendering.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class ProfilePage extends StatelessWidget {

  final String data;

  // Constructor to receive the data
    ProfilePage({required this.data});
  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(
        title: Text('$data'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromARGB(255, 160, 150, 150), 
        child:Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Your $data',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MemberPage()));
              },
              child: Text('Member'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ManagerPage()));
              },
              child: Text('Manager'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ElectricityPage()));
              },
              child: Text('Electricity'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NoticePage()));
              },
              child: Text('Notice Board'),
            ),
          ],
        ),
      ),
     ),
    );
  }
}

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Page'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('This is the Member Page'),
      ),
    );
  }
}

class ManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Page'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('This is the Manager Page'),
      ),
    );
  }
}

class ElectricityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Electricity Page'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('This is the Electricity Page'),
      ),
    );
  }
}

