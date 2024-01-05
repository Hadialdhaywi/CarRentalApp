import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String _baseURL = 'https://perfectionist-team.000webhostapp.com';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerUserName = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerAddress = TextEditingController(); // Added for address
  bool _loading = false;

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerUserName.dispose();
    _controllerPassword.dispose();
    _controllerAddress.dispose(); // Dispose address controller
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
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
          child: Form(
            key: _formKey,
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
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: _controllerName,
                    style: TextStyle(color: Colors.orange[100], fontSize: 20),
                    decoration: _myInputDecoration(label: "Name", icon: Icons.person),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: _controllerUserName,
                    style: TextStyle(color: Colors.orange[100], fontSize: 20),
                    decoration: _myInputDecoration(label: "User Name", icon: Icons.person),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter User Name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: _controllerPassword,
                    style: TextStyle(color: Colors.orange[100], fontSize: 20),
                    obscureText: true,
                    decoration: _myInputDecoration(label: "Password", icon: Icons.lock),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: _controllerAddress,
                    style: TextStyle(color: Colors.orange[100], fontSize: 20),
                    decoration: _myInputDecoration(label: "Address", icon: Icons.location_on),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Address';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loading
                      ? null
                      : () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                      });
                      saveCategory(
                        update,
                        _controllerName.text.toString(),
                        _controllerUserName.text.toString(),
                        _controllerPassword.text.toString(),
                        _controllerAddress.text.toString(), // Include address in the function call
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                  ),
                  child: _loading
                      ? SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orange[100],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
                    ),
                  )
                      : Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(visible: _loading, child: const CircularProgressIndicator())
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _myInputDecoration({required String label, required IconData icon}) {
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
}

void saveCategory(Function(String text) update, String name, String username, String password, String address) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseURL/register2.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'name': name,
        'username': username,
        'password': password,
        'address': address, // Include address in the request body
      }),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      update(response.body);
    }
  } catch (e) {
    update("connection error");
  }
}
