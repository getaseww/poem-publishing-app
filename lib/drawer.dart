import 'package:flutter/material.dart';
import 'package:p/about.dart';
import 'package:p/contact.dart';
import 'package:p/create_post.dart';
import 'package:p/login.dart';
import 'package:p/privacy.dart';
import 'package:p/profile.dart';
import 'package:p/register.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            accountName: Text(
              "ግጥም",
              style: TextStyle(fontSize: 18),
            ),
            accountEmail: Text(
              "gitem@gitem.com",
              style: TextStyle(fontSize: 16),
            ),
            arrowColor: Colors.black,
          ),
          ListTile(
            title: Text(
              "Add Post",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.add,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return PostForm();
              }));
            },
          ),
          ListTile(
            title: Text(
              "Profile",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.person,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return Profile();
              }));
            },
          ),
          ListTile(
            title: Text(
              "Login",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.login,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return LoginForm();
              }));
            },
          ),
          ListTile(
            title: Text(
              "Logout",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.logout,
              color: Colors.blue,
            ),
            onTap: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
          Divider(
            height: 10.0,
            color: Colors.black,
          ),
          ListTile(
            title: Text(
              "Contact Us",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.mail,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return Contact();
              }));
            },
          ),
          ListTile(
            title: Text(
              "About",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.info,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return AboutPage();
              }));
            },
          ),
          ListTile(
            title: Text(
              "Privacy Policy",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.security,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return Privacy();
              }));
            },
          ),
        ],
      ),
    );
  }
}
