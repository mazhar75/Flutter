import 'package:ex2app/calculationshow.dart';
import 'package:ex2app/dbhelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
  int yyear = 0;
  int mmonth = 0;
  

class CalculateResult extends StatefulWidget {
  @override
  _CalculateResultState createState() => _CalculateResultState();
}

class _CalculateResultState extends State<CalculateResult> {

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation Sheet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  yyear = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(labelText: 'Enter Year'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  mmonth = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(labelText: 'Enter Month'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowResult(
                  year: yyear,
                  month: mmonth,
                ),
              ),
            );

              },

              child: Text('Calculate'),
            ),
            SizedBox(height: 20.0),
           
          ],
        ),
      ),
    );
  }
}

