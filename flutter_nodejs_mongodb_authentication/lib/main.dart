import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        body: Forms(),
      ),
    );
  }
}

class Forms extends StatefulWidget {
  _FormsState createState() => _FormsState();
}

class _FormsState extends State<Forms> {
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
              margin:
                  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 100),
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
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
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
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
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>));
              print(mobilenumber);
              print(password);

              signup(mobilenumber, password);

              if (keys.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Processing Data")),
                );
              }
            },
            child: Container(
              width: size.width * 0.9,
              height: size.height * 0.08,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 4, 94, 251),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  )),
              child: Center(
                  child: Text(
                'Sign up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

signup(mobilenumber, password) async {
  //try {
  var url = Uri.parse("http://192.168.137.1:3000/signup");
  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'phonenumber': mobilenumber,
      'password': password,
    }),
  );

  print(response.body);
  // } catch (e) {
  //   print(e);
  // }
  // if (response.statusCode == 201) {
  //   // If the server did return a 201 CREATED response,
  //   // then parse the JSON.
  // } else {
  //   // If the server did not return a 201 CREATED response,
  //   // then throw an exception.
  //   throw Exception('Failed to create album.');
  //}
}
