import 'package:ex2app/dbhelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;


class MonthlyData extends StatefulWidget {
  final int month;
  final int year;


  MonthlyData({
    required this.month,
    required this.year,
  });

  @override
  _MonthlyDataState createState() => _MonthlyDataState();
}

class _MonthlyDataState extends State<MonthlyData> {
  var db;
  List<String> memberNames = [];
  List<double> meal = [];
  List<String> names = [];
  List<double> money = [];
  List<String>elec=[];
  double totalMeal = 0.0;
  double totalReceived=0.0;
  bool calculationsDone = false;

  @override
  void initState() {
    super.initState();
    _calculateAndFetchData();
  }

  Future<void> _calculateAndFetchData() async {
    try {
      db = await M.Db.create(url);
      await _fetchNames();
      await _fetchMeal();
      await _fetchMoney();
      await _fetchElectricity();
      setState(() {
        calculationsDone = true;
      });
    } catch (e) {
      print('Error during calculations: $e');
    }
  }

  Future<void> _fetchNames() async {
    try {
      await db.open();
      var memberCollection = db.collection(MEMBER);
      var cursor = await memberCollection.find(M.where.sortBy('name'));

      await cursor.forEach((element) {
        memberNames.add(element['name']);
      });

      names = memberNames;
      db.close();
    } catch (e) {
      print('Error fetching member names: $e');
    }
  }

  Future<void> _fetchElectricity() async {
    try {
      await db.open();
      var memberCollection = db.collection(GAS);
      for(int ind=0;ind<names.length;ind++){
        final document = await memberCollection.findOne(M.where
            .eq('name', names[ind])
            .eq('year', widget.year)
            .eq('month', widget.month));
            if(document != null)elec.add('YES');
            else elec.add('NO');
      }
      db.close();
    } catch (e) {
      print('Error fetching member names: $e');
    }
  }

  Future<void> _fetchMoney() async {
    try {
      await db.open();
      var moneyCollection = db.collection(RECIEVED);
      var cursor = await moneyCollection.find(M.where
        .eq('month', widget.month)
        .eq('year', widget.year));
      Map<String,double>X={};
      double Tot=0.0;

      
        
        await cursor.forEach((element) {
            for(var ind=0;ind<names.length;ind++){
              double key = element[names[ind]] ?? 0.0;
              X[names[ind]] = (X[names[ind]] ?? 0.0) + key;
              Tot+=key;
            }
        });
        totalReceived = Tot;
        for(var ind=0;ind<names.length;ind++){
         // money.add(X[names[ind]]);
          money.add(X[names[ind]] ?? 0.0);
        }
      db.close();
    } catch (e) {
      print('Error fetching money data: $e');
    }
  }

  Future<void> _fetchMeal() async {
    try {
      await db.open();
      var mealCollection = db.collection(MEAL);
      var cursor = await mealCollection.find(M.where
        .eq('month', widget.month)
        .eq('year', widget.year));

      Map<String, double> X = {};
      double Tot = 0.0;

      await cursor.forEach((element) {
        for (var ind = 0; ind < names.length; ind++) {
          double key = element[names[ind]] ?? 0.0;
          X[names[ind]] = (X[names[ind]] ?? 0.0) + key;
          Tot += key;
        }
      });
      totalMeal = Tot;
      for (var ind = 0; ind < names.length; ind++) {
        meal.add(X[names[ind]] ?? 0.0);
      }

      db.close();
    } catch (e) {
      print('Error fetching meal data: $e');
    }
  }
  // ...

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Data of ${widget.month}/${widget.year}'),
      centerTitle: true,
    ),
    body: calculationsDone
        ? SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Color.fromARGB(255, 205, 206, 202),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 185, 190, 192).withOpacity(0.2),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Money submission: $totalReceived'),
                          Text('Total Meal Count: $totalMeal'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Display cards for each member
                  for (var i = 0; i < names.length; i++)
                    Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Color.fromARGB(255, 226, 213, 202),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${names[i]}'),
                              SizedBox(height: 8.0),
                              Text('Meal Count: ${meal[i]}'),
                              SizedBox(height: 8.0),
                              Text('Money Submit: ${money[i]}'),
                              SizedBox(height: 8.0),
                              Text('Electricity Bill Paid: ${elec[i]}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          ),
  );
}

//...



 
}
