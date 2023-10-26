import 'package:ex2app/dbhelper/constant.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

const String mongodbUrl = url;
const String CollectionName = MEMBER;


class RemovePage extends StatefulWidget {
  @override
  _RemovePageState createState() => _RemovePageState();
}

class _RemovePageState extends State<RemovePage> {
  var db;

  @override
  void initState() {
    super.initState();
    _connectToMongoDB();
  }

  Future<void> _connectToMongoDB() async {
    db = await M.Db.create(url);
    await db.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MongoDB Data'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildCard(snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> data) {
    return Card(
      color: Colors.grey,
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(data['name'] ?? 'No Title'),
        trailing: ElevatedButton(
          onPressed: () {
           _deleteRecord(data['_id']);
            },
          child: Text('Delete'),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    if (db == null || !db.isConnected) {
      await _connectToMongoDB();
    }

    final UserCollection = db.collection(CollectionName);
    final cursor = await UserCollection.find(M.where.sortBy('name'));

    final List<Map<String, dynamic>> data = [];
    await cursor.forEach((element) {
      data.add(Map<String, dynamic>.from(element));
    });

    return data;
  }

Future<void> _deleteRecord(M.ObjectId recordId) async {
  final collection = db.collection(CollectionName);
  await collection.remove(M.where.id(recordId));
  setState(() {});
}




  @override
  void dispose() {
    db.close();
    super.dispose();
  }
}

class RemoveName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remove Name'),
      ),
      body: Center(
        child: Text('This is the RemoveName Page'),
      ),
    );
  }
}
