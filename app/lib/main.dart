import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petify/database.dart';
import 'package:petify/database/table_names.dart';

void main() {
  runApp(const PetifyApp());
}

const appTitle = 'Petify';

class PetifyApp extends StatelessWidget {
  const PetifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = appTitle;
    return MaterialApp(
      title: title,
      theme: ThemeData(
          primarySwatch: Colors.teal,
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            bodyText1: TextStyle(fontSize: 16.0),
            bodyText2: TextStyle(fontSize: 16.0),
            button: TextStyle(fontSize: 16.0),
          )),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: databaseInitialized ? dashboardWidget() : loadingWidget(),
      ),
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
            if (snapshot.data![petTableName].isEmpty) {
              return Column(children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Willkommen!',
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    )),
                const Text(
                  'Starte mit $appTitle, indem Du ein Haustier über den Plus-Knopf unten rechts anlegst.',
                )
              ]);
            } else {
              final petList = Text(jsonEncode(snapshot.data![petTableName]));
              dynamic petificationList;
              if (snapshot.data![petificationTableName].isEmpty) {
                petificationList = const Text(
                    "Füge eine Petification hinzu, indem Du auf den Plus-Knopf unten rechts drückst und dann auf das Glocken-Icon.");
              } else {
                petificationList =
                    Text(jsonEncode(snapshot.data![petificationTableName]));
              }
              return Column(
                children: [petList, petificationList],
              );
            }
          } else {
            return loadingWidget();
          }
        });
  }

  Widget loadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }
}
