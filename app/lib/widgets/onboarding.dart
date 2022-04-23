import 'package:flutter/material.dart';
import 'package:petify/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingWidget extends StatefulWidget {
  final DatabaseProvider databaseProvider;

  const OnboardingWidget({Key? key, required this.databaseProvider})
      : super(key: key);

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  int page = 1;

  Future<void> _skipTutorial() async {
    // TODO: Render dashboard; should probably include listening on prefs and/or routing
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingFinished', true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        AppLocalizations.of(context)!.welcome_to_petify,
        style: const TextStyle(
          fontSize: 24.0,
        ),
      ),
      ElevatedButton(onPressed: _skipTutorial, child: const Text("Skip"))
    ]);
  }
}
