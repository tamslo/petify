import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:petify/database/table_names.dart';

class DashboardWidget extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const DashboardWidget({Key? key, required this.snapshot}) : super(key: key);

  Widget renderContent(BuildContext context) {
    if (snapshot.data![petTableName].isEmpty) {
      return Column(children: [
        Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
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
    return Stack(children: [renderContent(context), renderAddButton()]);
  }
}
