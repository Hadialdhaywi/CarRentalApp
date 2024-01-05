import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'register2.dart';

import 'account.dart'; //

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  late String errorMessage;
  late bool error = false, showProgress = false;

  late String username, password;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status on initialization
  }

  _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // If the user is already logged in, navigate to the account page
      Navigator.pushReplacementNamed(context, '/account');
    }
  }

  _saveLoginStatus(String username, String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('username', username);
    prefs.setString('uid', uid);
  }



  Future<void> startLogin() async {
    String apiUrl = "https://perfectionist-team.000webhostapp.com/login.php";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData["error"]) {
          setState(() {
            showProgress = false;
            error = true;
            errorMessage = jsonData["message"];
          });
        } else {
          if (jsonData["success"]) {
            setState(() {
              error = false;
              showProgress = false;
            });
            // Save the data returned from the server and navigate to the account page
            _saveLoginStatus(username, jsonData["uid"]);


            Navigator.pushReplacementNamed(context, '/car_list');
          } else {
            setState(() {
              showProgress = false;
              error = true;
              errorMessage = "Something went wrong.";
            });
          }
        }
      } else {
        setState(() {
          showProgress = false;
          error = true;
          errorMessage = "Error connecting the server.";
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        showProgress = false;
        error = true;
        errorMessage = "Error connecting the server.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.orange,
                Colors.deepOrangeAccent,
                Colors.red,
                Colors.redAccent,
              ],
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 80),
                child: Text(
                  "Car Rental",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Sign In using Email and Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.all(10),
                child: error ? errorMessageWidget(errorMessage) : Container(),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: EdgeInsets.only(top: 10),
                child: Container(
                  height: 60,
                  child: TextField(
                    controller: _usernameController,
                    style: TextStyle(color: Colors.orange[100], fontSize: 20),
                    decoration: myInputDecoration(
                      label: "Username",
                      icon: Icons.person,
                    ),
                    onChanged: (value) {
                      username = value;
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 60,
                  child: TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.orange[100], fontSize: 20),
                    obscureText: true,
                    decoration: myInputDecoration(
                      label: "Password",
                      icon: Icons.lock,
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showProgress = true;
                      });
                      startLogin();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                    ),
                    child: showProgress
                        ? SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.orange[100],
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepOrangeAccent),
                      ),
                    )
                        : Text(
                      "LOGIN NOW",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the registration page using Navigator.push
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                child: Text(
                  "REGISTER",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 20),
                child: InkResponse(
                  onTap: () {
                    // action on tap
                  },
                  child: Text(
                    "Forgot Password? Troubleshoot",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration myInputDecoration(
      {required String label, required IconData icon}) {
    return InputDecoration(
      hintText: label,
      hintStyle: TextStyle(color: Colors.orange[100], fontSize: 20),
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 20, right: 10),
        child: Icon(
          icon,
          color: Colors.orange[100],
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.orange, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.orange, width: 1),
      ),
      fillColor: Color.fromRGBO(251, 140, 0, 0.5),
      filled: true,
    );
  }

  Widget errorMessageWidget(String text) {
    return Container(
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.red,
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 6.0),
            child: Icon(Icons.info, color: Colors.white),
          ),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }
}