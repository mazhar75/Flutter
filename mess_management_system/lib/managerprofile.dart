
import 'package:ex2app/updatepassword.dart';
import 'package:flutter/material.dart';
class ManagerProfile extends StatefulWidget {
  @override
  _ManagerProfileState createState() => _ManagerProfileState();
}

class _ManagerProfileState extends State<ManagerProfile> {
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
                      builder: (context) => UpdatePasswordPage(),
                    ),
                  );
                  print('Update Password');
                },
              ),
              SizedBox(height: 16), // Adjust the height as needed
              GlassButton(
                label: 'Add Member',
                onPressed: () {
                  // Handle add member action
                  print('Add Member');
                },
              ),
              SizedBox(height: 16), // Adjust the height as needed
              GlassButton(
                label: 'Remove Member',
                onPressed: () {
                  // Handle remove member action
                  print('Remove Member');
                },
              ),
              SizedBox(height: 16), // Adjust the height as needed
              GlassButton(
                label: 'Entry Today\'s Data',
                onPressed: () {
                  // Handle entry today's data action
                  print('Entry Today\'s Data');
                },
              ),
              SizedBox(height: 16), // Adjust the height as needed
              GlassButton(
                label: 'Calculation',
                onPressed: () {
                  // Handle calculation action
                  print('Calculation');
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
