import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petify',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Roboto'),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Petify',
            style: TextStyle(
                fontFamily: 'Meow Script',
                fontWeight: FontWeight.bold,
                fontSize: 28),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: const [
              Text('Bevorstehende Petifications',
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
