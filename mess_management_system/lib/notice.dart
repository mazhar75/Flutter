import 'package:ex2app/addnotice.dart';
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
      var db, userCollection;
      db = await M.Db.create(url);
      await db.open();
      userCollection = db.collection(NOTICE);

      var cursor = await userCollection.find(M.where).toList();
      var x = 5;

      if (cursor.isNotEmpty) {
        var lastFiveRecords = cursor.length > x ? cursor.sublist(cursor.length - x) : cursor;

        setState(() {
          data = lastFiveRecords;
          isLoading = false;
        });
      } else {
        print('There is no data to show!');
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
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.pink[300],
                  child: ListTile(
                    title: Text(
                      data[index]['name'].toString(),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${data[index]['date']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Description: ${data[index]['description']}',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotice()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}
