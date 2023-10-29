import 'package:ex2app/dbhelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class NameListScreen extends StatefulWidget {
  @override
  _NameListScreenState createState() => _NameListScreenState();
}

class _NameListScreenState extends State<NameListScreen> {
  List<String> names = [];
  Map<String, bool> existingNames = {};
  String? selectedName;

  @override
  void initState() {
    super.initState();
    fetchNames().then((result) {
      setState(() {
        names = result;
      });
      fetchExistingNames();
    });
  }

  Future<void> fetchExistingNames() async {
    var db = await M.Db.create(url);
    await db.open();

    var collection = db.collection(GAS);
    final currentDate = DateTime.now();
    int currentYear = currentDate.year;
    int currentMonth = currentDate.month;

    var cursor = await collection.find({
      'month': currentMonth,
      'year' :currentYear,
    });

    await cursor.forEach((element) {
      existingNames[element['name']] = true;
    });

    db.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Names'),
      ),
      body: Column(
        children: [
          // Display the fetched names
          ListView.builder(
            shrinkWrap: true,
            itemCount: names.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  children: [
                    Text(
                      names[index],
                      style: TextStyle(
                        color: selectedName == names[index] || existingNames[names[index]] == true
                            ? Colors.red // Keep red for existing names or selected name
                            : Colors.blue, // Blue for non-existing names
                        fontWeight: existingNames[names[index]] == true ? FontWeight.bold : null,
                      ),
                    ),
                    if (existingNames[names[index]] == true)
                      Icon(
                        Icons.done,
                        color: Colors.green,
                      ), // Show a checkmark if the name is existing
                  ],
                ),
                onTap: () {
                  setState(() {
                    if (existingNames[names[index]] != true) {
                      // Toggle between blue and red only if the name is not existing
                      selectedName = selectedName == names[index] ? null : names[index];
                    }
                  });
                },
              );
            },
          ),
          SizedBox(height: 20.0),
          // Display the "Got" button
          ElevatedButton(
            onPressed: () {
              if (selectedName != null) {
                // Call a function to insert the selectedName into "electricitybillpaidperson"
                insertIntoElectricityBillPaidPerson(selectedName!);
                fetchExistingNames();
              }
            },
            child: Text('Got'),
          ),
        ],
      ),
    );
  }

  Future<List<String>> fetchNames() async {
    var db = await M.Db.create(url);
    await db.open();

    var collection = db.collection(MEMBER);
    var cursor = await collection.find(M.where.sortBy('name'));

    List<String> names = [];

    await cursor.forEach((element) {
      names.add(element['name']);
    });

    db.close();
    return names;
  }

  Future<void> insertIntoElectricityBillPaidPerson(String name) async {
    var db = await M.Db.create(url);
    await db.open();

    var collection = db.collection(GAS);

    final currentDate = DateTime.now();
    int currentYear = currentDate.year;
    int currentMonth = currentDate.month;

    var existingEntry = await collection.findOne({
      'name': name,
      'month': currentMonth,
    });

    if (existingEntry == null) {
      await collection.insert({'name': name, 'month': currentMonth ,'year':currentYear});
    }

    db.close();
  }
}

void main() {
  runApp(MaterialApp(
    home: NameListScreen(),
  ));
}
