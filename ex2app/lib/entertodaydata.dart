import 'package:ex2app/dbhelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

final a = BAZAR;
final b = MEAL;
final c = RECIEVED;

class DataEntry extends StatefulWidget {
  @override
  _DataEntryState createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {
  var db;
  List<String> memberNames = [];
  List<TextEditingController> nameControllers = [];
  List<double> Meal = [];
  List<double> Money = [];
  int dateValue = 0;
  late int currentYear;
  late int currentMonth;
  double DailyCost = 0.0;

  // Declare the 'names' list at the class level
  List<String> names = [];

  bool dataAlreadyInserted = false;

  @override
  void initState() {
    super.initState();
    _connectToMongoDB();
  }

  Future<void> _connectToMongoDB() async {
    db = await M.Db.create(url);
    await db.open();
    await _fetchNames();
    _getCurrentDate();
  }

  Future<void> _fetchNames() async {
    var memberCollection = db.collection(MEMBER);
    var cursor = await memberCollection.find(M.where.sortBy('name'));

    await cursor.forEach((element) {
      memberNames.add(element['name']);
      nameControllers.add(TextEditingController());
      Meal.add(0.0);
      Money.add(0.0);
    });

    // Set 'names' with the fetched member names
    names = memberNames;

    setState(() {});
  }

  void _getCurrentDate() {
    final currentDate = DateTime.now();
    currentYear = currentDate.year;
    currentMonth = currentDate.month;
  }

  Future<bool> _submitForm() async {
    var userCollection = db.collection(a);
    final document = await userCollection.findOne(M.where
      .eq('date', dateValue)
      .eq('month', currentMonth)
      .eq('year', currentYear));

    if (document != null) {
      setState(() {
        dataAlreadyInserted = true;
      });
    } else {
      // Continue with the data insertion logic
      Map<String, dynamic> userMap = {
        'date': dateValue,
        'month': currentMonth,
        'year': currentYear,
        'cost': DailyCost,
      };
      try {
        var result = await userCollection.insert(userMap);
        if (result.isSuccess) {
          print('Dailycost insertion successful');
        } else {
          print('something error');
        }
      } catch (e) {
        print(e.toString());
      }

      var userMeal = db.collection(b);
      Map<String, dynamic> UserMeal = {
        'date': dateValue,
        'month': currentMonth,
        'year': currentYear,
        ...Map.fromIterable(names, key: (e) => e, value: (e) => Meal[names.indexOf(e)]),
      };
      try {
        var result = await userMeal.insert(UserMeal);
        if (result.isSuccess) {
          print('Meal insertion Successful');
        } else {
          print('something error');
        }
      } catch (e) {
        print(e.toString());
      }

      var userMoney = db.collection(c);
      Map<String, dynamic> UserMoney = {
        'date': dateValue,
        'month': currentMonth,
        'year': currentYear,
        ...Map.fromIterable(names, key: (e) => e, value: (e) => Money[names.indexOf(e)]),
      };
      try {
        var result = await userMoney.insert(UserMoney);
        if (result.isSuccess) {
          print('Meal insertion Successful');
        } else {
          print('something error');
        }
      } catch (e) {
        print(e.toString());
      }

      // Reset the flag after successful insertion
      setState(() {
        dataAlreadyInserted = false;
      });
    }

    // Return a boolean indicating whether the data was already inserted
    return dataAlreadyInserted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Entry Form'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                dateValue = int.tryParse(value) ?? 0;
              });
            },
            decoration: InputDecoration(labelText: 'Enter Date'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.0),
          TextField(
            onChanged: (value) {
              setState(() {
                DailyCost = double.tryParse(value) ?? 0.0;
              });
            },
            decoration: InputDecoration(labelText: 'Enter Today\'s cost'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16.0),

          for (var index = 0; index < memberNames.length; index++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${memberNames[index]}'),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      Meal[index] = double.tryParse(value) ?? 0.0;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Meal taken'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      Money[index] = double.tryParse(value) ?? 0.0;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Money submitted'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 16.0),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool res = await _submitForm();

          if (res) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Data Already inserted.'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Data inserted successfully.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },

        child: Icon(Icons.check),
      ),
    );
  }

  @override
  void dispose() {
    db.close();
    for (var controller in nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
