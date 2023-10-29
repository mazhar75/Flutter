

import 'package:ex2app/ElectricityManager/billpayentry.dart';
import 'package:ex2app/ElectricityManager/electricitypassupdate.dart';
import 'package:flutter/material.dart';



class EManagerProfile extends StatefulWidget {
  @override
  _EManagerProfileState createState() => _EManagerProfileState();
}

class _EManagerProfileState extends State<EManagerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Profile'),
      ),
      body: Container(
        color: Colors.purple,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassButton(
                label: 'Update Password',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>EUpdatePasswordPage(),
                    ),
                  );
                  print('Update Password');
                },
              ),
              SizedBox(height: 16), // Adjust the height as needed
              GlassButton(
                label: 'Add Member',
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NameListScreen(),
                    ),
                  );
                  print('Add Member');
                },
              ),
              
            ],
          ),
        ),
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
