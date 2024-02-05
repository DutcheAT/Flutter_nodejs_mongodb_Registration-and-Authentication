import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_nodejs_mongodb_authentication/homepage.dart';
import 'package:flutter_nodejs_mongodb_authentication/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Signup_page extends StatelessWidget {
  const Signup_page({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Forms",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Form"),
        ),
        body: SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<SignupForm> {
  final keys = GlobalKey<FormState>();

  String mobilenumber = "";
  String password = "";

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = true; // Prevents focus if tap on eye
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: keys,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 20, top: 100),
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 40),
                      child: Text("Mobile Number",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter Mobile Number",
                            isDense: true, // Reduces height a bit
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // No border
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) => {mobilenumber = value},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Mobile Number";
                            } else {
                              return null;
                            }
                          }),
                    ),
                  ])),
          Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text("PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscured,
                        focusNode: textFieldFocusNode,
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          isDense: true, // Reduces height a bit
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none, // No border
                            borderRadius: BorderRadius.circular(
                                12), // Apply corner radius
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: _toggleObscured,
                              child: Icon(
                                _obscured
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        onChanged: (value) => {password = value},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Password";
                          } else {
                            return null;
                          }
                        }),
                  ),
                ],
              )),
          InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await signup(mobilenumber, password);
              String? token = prefs.getString("token");
              if (token != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Homepage()), // Updated line
                );
              }
              if (keys.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Processing Data")),
                );
              }
            },
            child: Container(
              width: size.width * 0.6,
              height: 50, // Adjusted height to fit the button properly
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green,
              ),
              alignment: Alignment.center,
              child: const Text(
                "Signup",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//10.232.96.249
signup(mobilenumber, password) async {
  //try {
  var url = Uri.parse("http://10.232.96.249:3000/signup");
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': mobilenumber,
      'password': password,
    }),
  );

  print(response.body);
  var parse = jsonDecode(response.body);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', parse["token"]);
}
