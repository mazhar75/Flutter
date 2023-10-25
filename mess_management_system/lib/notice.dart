import 'dart:math';

import 'package:ex2app/dbhelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLatestRecords();
  }

  Future<void> fetchLatestRecords() async {
    try {
      final db = M.Db(url);
      await db.open();

     // final collection = db.collection('notice');

      var collection = db.collection(NOTICE);
      var count = await collection.count();
      var cursor = await collection.find(M.where).toList();
      var x=5;

      if (cursor.isNotEmpty) {
        final firstTenRecords = cursor.take(min(x,count)).toList();

        setState(() {
          data = firstTenRecords;
          isLoading = false;
        });
      } else {
        print('There is no data to show !');
        setState(() {
          isLoading = false;
        });
      }

    } catch (e) {
      print('Error fetching data: $e');
      // Handle error, show error message, etc.
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest News'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : DataTable(
              columns: [
                DataColumn(label: Text('name')),
                DataColumn(label: Text('date')),
                DataColumn(label: Text('description')),
                // Add more DataColumn widgets for each field in your MongoDB documents
              ],
              rows: data.map((record) {
                return DataRow(
                  cells: [
                    DataCell(Text(record['name'].toString())),
                    DataCell(Text(record['date'].toString())),
                    DataCell(Text(record['description'].toString())),
                    // Add more DataCell widgets for each field in your MongoDB documents
                  ],
                );
              }).toList(),
            ),
    );
  }
}
