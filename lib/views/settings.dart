import 'package:flutter/material.dart';
import 'package:to_do_app/services/auth.dart';
import 'package:to_do_app/services/sharedpreferences.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final AuthService _auth = AuthService();
  int _counter = 0;

  _SettingsViewState() {
    getCount().then((val) => setState(() {
          _counter = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                // light indigo background colour, stretching across full width
                color: Colors.indigo[50],
                width: double.infinity,
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back button to return to home screen
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BackButton(),
                            ),
                            Text(
                              'Settings',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 25.0,
                              ),
                            ),
                            // button to sign out of application
                            TextButton(
                              child: Text("Sign out"),
                              onPressed: () async {
                                await _auth.signOut();
                                Navigator.pop(context);
                              },
                            ),
                          ]),
                      // display total number of tasks user has added (uses shared preferences)
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(
                            'You have added $_counter tasks since downloading Let\'s Do!',
                            style: TextStyle(fontSize: 20.0, height: 1.5)),
                      ),
                      Icon(Icons.info_outline)
                    ],
                  )
                ]))));
  }
}
