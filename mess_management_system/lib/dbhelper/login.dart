import 'package:flutter/material.dart';
import 'package:ex2app/dbhelper/constant.dart';
import 'package:ex2app/dbhelper/mongodb.dart';
import 'package:ex2app/manager.dart';
import 'package:ex2app/notice.dart';

class ProfilePage extends StatelessWidget {
  final String data;

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Your $data',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              GlassButton(
                label: 'Member',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MemberPage()));
                },
              ),
              GlassButton(
                label: 'Manager',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ManagerPage()));
                },
              ),
              GlassButton(
                label: 'Electricity',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ElectricityPage()));
                },
              ),
              GlassButton(
                label: 'Notice Board',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NoticePage()));
                },
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

class GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  GlassButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.3),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60, // Adjust the height as needed
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
