import 'package:flutter/material.dart';
import 'package:p/create_post.dart';
import 'package:p/getdata.dart';
import 'package:p/posts.dart';
import 'package:p/profile.dart';
import 'package:p/register.dart';
import 'package:provider/provider.dart';
import './auth.dart';
import 'login.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => AuthProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gitem',
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          body: Center(child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              switch (auth.isAuthenticated) {
                case true:
                  return Posts();
                default:
                  return LoginForm();
              }
            },
          )),
        ));
  }
}
