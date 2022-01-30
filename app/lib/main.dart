import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petify/database.dart';

void main() {
  runApp(const PetifyApp());
}

class PetifyApp extends StatelessWidget {
  const PetifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Petify';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
      home: const PetifyHome(title: title),
    );
  }
}

class PetifyHome extends StatefulWidget {
  const PetifyHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PetifyHome> createState() => _PetifyHomeState();
}

class _PetifyHomeState extends State<PetifyHome> {
  late DatabaseProvider databaseProvider;

  @override
  void initState() {
    super.initState();
    databaseProvider = DatabaseProvider();
    databaseProvider.initializeDatabase().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
              fontFamily: 'Meow Script',
              fontWeight: FontWeight.bold,
              fontSize: 28),
        ),
      ),
      body: dashboardWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ignore: avoid_print
          print(
              'TODO: Show instances that can be added (probably include a package for this');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget dashboardWidget() {
    return FutureBuilder(
        future: databaseProvider.retrieveData(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            return Text(jsonEncode(snapshot.data));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
