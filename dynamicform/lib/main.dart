import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  List<TextEditingController> controllers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Text Fields'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controllers.length,
                itemBuilder: (context, index) {
                  return TextFormField(
                    controller: controllers[index],
                    decoration: InputDecoration(
                      labelText: 'Text Field ${index + 1}',
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Add a new TextEditingController when the button is pressed
                setState(() {
                  controllers.add(TextEditingController());
                });
              },
              child: Text('Add Text Field'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Print the values of all text fields
                for (var controller in controllers) {
                  print(controller.text);
                }
              },
              child: Text('Print Values'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all the controllers to avoid memory leaks
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
