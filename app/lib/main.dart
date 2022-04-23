import 'package:flutter/material.dart';
import 'package:petify/database.dart';
import 'package:petify/database/table_names.dart';
import 'package:petify/widgets/dashboard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:petify/widgets/loading.dart';
import 'package:petify/widgets/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<bool> _isOnboardingFinished() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingFinished') ?? false;
  }

  Widget renderContent(DatabaseProvider databaseProvider) {
    return FutureBuilder(
        future: _isOnboardingFinished(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            bool onboardingFinished = snapshot.data!;
            if (onboardingFinished) {
              return DashboardWidget(databaseProvider: databaseProvider);
            } else {
              return OnboardingWidget(databaseProvider: databaseProvider);
            }
          } else {
            return loadingWidget();
          }
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
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: databaseInitialized
            ? renderContent(databaseProvider)
            : loadingWidget(),
      ),
    );
  }
}
