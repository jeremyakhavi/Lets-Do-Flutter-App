import 'package:flutter/material.dart';
import 'package:to_do_app/services/auth.dart';
import 'package:to_do_app/services/sharedpreferences.dart';
import 'package:share/share.dart';
import 'package:to_do_app/views/userguide.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;

/* 
-- USE INTENTS TO MOVE TO AN OUTSIDE APP
  - this is implemented by using intents to open up the mail app to email the dev

-- USE SHARED PREFERENCES
  - this is implemented here to view how many tasks have been created using the app

-- IMPLEMENT AND USE A SHAREACTIONPROVIDER
  - this is implemented in the floating share button, allowing users to share text about the app
*/

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // initialise Authorisation service
  final AuthService _auth = AuthService();

  int _counter = 0;

  _SettingsViewState() {
    // get count of tasks created from shared preferences
    getCount().then((val) => setState(() {
          _counter = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                color: Colors.indigo[50],
                width: double.infinity,
                child: Stack(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      // message to inform user about button for user guide
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(
                            'To view the user guide for this app, please tap the button in the bottom right',
                            style: TextStyle(fontSize: 14.0, height: 1.5)),
                      ),
                      const Divider(
                        height: 0,
                        thickness: 2.5,
                        indent: 20,
                        endIndent: 20,
                      ),
                      // display total number of tasks user has added (uses shared preferences)
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(
                            'You have added $_counter tasks since downloading Let\'s Do!',
                            style: TextStyle(fontSize: 20.0, height: 1.5)),
                      ),
                      const Divider(
                        height: 0,
                        thickness: 2.5,
                        indent: 20,
                        endIndent: 20,
                      ),
                      // uses Intents to open mail app with auto filled email address
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            Text(
                                'Got any feedback? Want to report an issue? Suggest a feature?',
                                style: TextStyle(fontSize: 14.0, height: 1.5)),
                            TextButton(
                                child: Text('Email us'),
                                onPressed: () {
                                  android_intent.Intent()
                                    ..setAction(
                                        android_action.Action.ACTION_VIEW)
                                    ..setData(Uri(
                                        scheme: "mailto",
                                        path: "jeremyakhavi@me.com"))
                                    ..startActivity()
                                        .catchError((e) => print(e));
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // button to share app using ShareActionProvider
                  Positioned(
                    left: 25.0,
                    bottom: 20.0,
                    child: SizedBox(
                        height: 75,
                        width: 75,
                        child: Builder(builder: (BuildContext context) {
                          return FloatingActionButton(
                              heroTag: "shareBtn",
                              onPressed: () => _onShare(context),
                              child: const Icon(Icons.ios_share),
                              backgroundColor: Colors.lightBlue[900]);
                        })),
                  ),
                  // button to open WebView for userguide
                  Positioned(
                    right: 25.0,
                    bottom: 25.0,
                    child: SizedBox(
                      height: 75,
                      width: 75,
                      child: FloatingActionButton(
                          heroTag: "userGuideBtn",
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WebViewWidget()));
                          },
                          child: const Icon(Icons.menu_book),
                          backgroundColor: Colors.purple[600]),
                    ),
                  ),
                ]))));
  }

  // function to bring up share sheet using ACTION_SEND Intent on Android
  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(
        'I have created $_counter tasks with Let\'s Do, talk about productivity!',
        subject: 'I am being so productive with Lets Do',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
