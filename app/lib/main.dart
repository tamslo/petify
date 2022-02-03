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
  bool databaseInitialized = false;

  @override
  void initState() {
    super.initState();
    databaseProvider = DatabaseProvider();
    databaseProvider.initializeDatabase().whenComplete(() async {
      print("Database initialization complete");
      databaseInitialized = true;
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
      body: databaseInitialized ? dashboardWidget() : loadingWidget(),
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
    print("Rendering dashboard");
    return FutureBuilder(
        future: databaseProvider.retrieveData(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            return Text(jsonEncode(snapshot.data));
          } else {
            return loadingWidget();
          }
        });
  }

  Widget loadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }
}
