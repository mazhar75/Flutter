
import 'package:ex2app/dbhelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class ShowResult extends StatefulWidget {
  final int month;
  final int year;

  ShowResult({
    required this.month,
    required this.year,
  });

  @override
  _ShowResultState createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  var db;
  List<String> memberNames = [];
  List<double> meal = [];
  List<double> money = [];
  List<double> finalHisab = [];
  List<String> names = [];
  double totalCost = 0.0;
  double totalReceived = 0.0;
  double totalMeal = 0.0;
  double mealRate = 0.0;
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
      await _fetchMoney();
      await _fetchMeal();
      await _fetchTotalCost();
      await _fetchFinalHisab();
      print(names);
      print(money);
      

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

        Map<String,double>X={};
        double Tot=0.0;

      
        
        await cursor.forEach((element) {
            for(var ind=0;ind<names.length;ind++){
              double key = element[names[ind]] ?? 0.0;
              X[names[ind]] = (X[names[ind]] ?? 0.0) + key;
              Tot+=key;
            }
        });
        totalMeal=Tot;
        for(var ind=0;ind<names.length;ind++){
         // money.add(X[names[ind]]);
          meal.add(X[names[ind]] ?? 0.0);
        }

      
      db.close();
    } catch (e) {
      print('Error fetching meal data: $e');
    }
  }

  Future<void> _fetchTotalCost() async {
    try {
      await db.open();
      var costCollection = db.collection(BAZAR);
      var cursor = await costCollection.find(M.where
        .eq('month', widget.month)
        .eq('year', widget.year));

      await cursor.forEach((element) {
        totalCost = totalCost + (element['cost'] ?? 0.0);
      });
      db.close();
    } catch (e) {
      print('Error fetching total cost data: $e');
    }
  }

  Future<void> _fetchFinalHisab() async {
    mealRate = totalCost / totalMeal;

    for (var ind = 0; ind < names.length; ind++) {
      double tot = money[ind] - mealRate * meal[ind];
      finalHisab.add(tot);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation Sheet'),
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
                      color: Color.fromARGB(255, 224, 230, 224),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Cost: $totalCost'),
                            Text('Total Received: $totalReceived'),
                            Text('Total Meal: $totalMeal'),
                            Text('Meal Rate: $mealRate'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Card(
  color: const Color.fromARGB(255, 249, 252, 249),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Member\'s Final Calculation:'),
        SizedBox(height: 10.0),
        for (var i = 0; i < names.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${names[i]}: ${finalHisab[i]}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0), // Adjust the height as needed
            ],
          ),
      ],
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
}