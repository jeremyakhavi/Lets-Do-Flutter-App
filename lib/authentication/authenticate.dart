import 'package:flutter/material.dart';
import 'package:to_do_app/authentication/register.dart';
import 'package:to_do_app/authentication/signin.dart';

// Stateful widget used for authentication, it allows for a toggle
// between either the login view, or the register view

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
