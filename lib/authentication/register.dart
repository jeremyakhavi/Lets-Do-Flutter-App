import 'package:flutter/material.dart';
import 'package:to_do_app/services/auth.dart';
import 'package:to_do_app/widgets.dart';

// Stateful Widget for the Register view, allows a user to register for a
// Let's Do account, if they don't already have one, and start using the app

class Register extends StatefulWidget {
  final Function toggleView;

  // screenHeight is used to determine size of logo image to display
  final double screenHeight =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  // key used to identify the form
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  FocusNode _focusEmail, _focusPassword;

  // initial states of the text fields
  String email = '';
  String password = '';
  String error = '';

  @override
  void initState() {
    super.initState();
    _focusEmail = FocusNode();
    _focusPassword = FocusNode();
  }

  void disposeFocus() {
    _focusEmail.dispose();
    _focusPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // returns loading widget if page is loading, otherwise returns scaffold
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.indigo[50],
            appBar: AppBar(
              automaticallyImplyLeading: false, // hide back button
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text('Sign up to Let\'s Do',
                  style: TextStyle(color: Colors.blue)),
              actions: <Widget>[
                // button to allow user to toggle between register and sign in
                TextButton.icon(
                    icon: Icon(Icons.person),
                    label: Text('Sign In'),
                    onPressed: () {
                      widget.toggleView();
                    }),
              ],
            ),
            body: Column(
              children: [
                Container(
                  // logo image is 0.1 * screenHeight to ensure there are no overflows
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    height: widget.screenHeight * 0.1,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                            focusNode: _focusEmail,
                            decoration:
                                // decoration is a constant from widgets.dart file
                                // allows for consistency and no duplication of code
                                textInputDecoration.copyWith(hintText: 'Email'),
                            // placeholders in email and password field
                            // when field is changed trim the value to remove extra tabs or spaces
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => email = val.trim());
                            },
                            onFieldSubmitted: (value) {
                              _focusPassword.requestFocus();
                            }),
                        SizedBox(height: 20.0),
                        TextFormField(
                            focusNode: _focusPassword,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Password'),
                            obscureText: true,
                            validator: (val) => val.length < 6
                                ? 'Enter a password 6+ chars long'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val.trim());
                            }),
                        SizedBox(height: 20.0),
                        // button to register new account using email and password provided
                        TextButton(
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              // open loading widget is form is valid whilst registering credentials
                              setState(() => loading = true);
                              dynamic result = await _auth.registerWithEmail(
                                  email, password);
                              // if no success returned then show error message
                              if (result == null) {
                                setState(() {
                                  error = 'please enter a valid email';
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
