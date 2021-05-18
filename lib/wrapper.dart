import 'package:flutter/material.dart';
import 'package:to_do_app/authentication/authenticate.dart';
import 'package:to_do_app/models/user_model.dart';
import 'package:to_do_app/views/home.dart';
import 'package:provider/provider.dart';

/*
Wrapper is used to return either the home or authenticate view depending
user logged in or not
*/

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    // return either home or authenticate depending on login
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
