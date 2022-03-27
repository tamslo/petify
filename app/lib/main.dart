import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petify/database.dart';
import 'package:petify/database/table_names.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
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
          print('TODO: Show dialog to add petification');
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
                    child: Text(
                      AppLocalizations.of(context)!.welcome,
                      style: const TextStyle(
                        fontSize: 24.0,
                      ),
                    )),
              ]);
            } else {
              final petList = Text(jsonEncode(snapshot.data![petTableName]));
              dynamic petificationList;
              petificationList =
                  Text(jsonEncode(snapshot.data![petificationTableName]));
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
