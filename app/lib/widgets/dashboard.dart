import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:petify/database.dart';
import 'package:petify/database/table_names.dart';
import 'package:petify/widgets/loading.dart';

class DashboardWidget extends StatelessWidget {
  final DatabaseProvider databaseProvider;

  const DashboardWidget({Key? key, required this.databaseProvider})
      : super(key: key);

  Widget renderContent(BuildContext context, Map? data) {
    final petList = Text(jsonEncode(data![petTableName]));
    final petificationList = Text(jsonEncode(data[petificationTableName]));
    return Column(
      children: [petList, petificationList],
    );
  }

  Widget renderAddButton() {
    return Positioned(
        bottom: 0,
        right: 0,
        child: ElevatedButton(
          onPressed: () {
            // ignore: avoid_print
            print("TODO: Add something");
          },
          child: const Icon(Icons.add, color: Colors.white),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: databaseProvider.retrieveData(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map? data = snapshot.data;
            return Stack(
                children: [renderContent(context, data), renderAddButton()]);
          } else {
            return loadingWidget();
          }
        });
  }
}
