import 'package:flutter/material.dart';
import 'package:flutter_nodejs_mongodb_authentication/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    clearprefs() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }

    clearprefs();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()), // Updated line
            );
          },
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to Flutter Home!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
