import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Text(
          "Privacy Policy Page",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
