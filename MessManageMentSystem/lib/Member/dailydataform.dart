import 'package:ex2app/Member/showingdailydata.dart';
import 'package:ex2app/dbhelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
  int yyear = 0;
  int mmonth = 0;
  int dday=0;
  

class ShowDailyData extends StatefulWidget {
  @override
  _ShowDailyDataState createState() => _ShowDailyDataState();
}

class _ShowDailyDataState extends State<ShowDailyData> {

 
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
             TextField(
              onChanged: (value) {
                setState(() {
                  dday = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(labelText: 'Enter Date'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DailyData(
                  year: yyear,
                  month: mmonth,
                  day:dday,
                ),
              ),
            );

              },

              child: Text('Show'),
            ),
            SizedBox(height: 20.0),
           
          ],
        ),
      ),
    );
  }
}

