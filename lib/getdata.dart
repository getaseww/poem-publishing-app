import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p/drawer.dart';
import 'package:provider/provider.dart';
import './auth.dart';
import 'dart:convert';
import 'models/user.dart';
import 'utils/constants.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchInfo();
  }

  Future<List<User>> fetchInfo() async {
    List<User> info;
    String token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    final response = await http.get('$API_URL/userinfo', headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      for (int i = 0; i < data.length; i++) {
        info.add(User.fromJson(data[i]));
      }
      return info;
    } else {
      throw Exception('Problem occure while loading posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('heloo'),
        backgroundColor: Colors.teal,
      ),
      drawer: NavDrawer(),
      body: Column(
        children: <Widget>[
          UserInfoBuilder(futureUsers: futureUsers),
        ],
      ),
    );
  }
}

class UserInfoBuilder extends StatelessWidget {
  const UserInfoBuilder({
    Key key,
    @required this.futureUsers,
  }) : super(key: key);

  final Future<List<User>> futureUsers;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
                child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                User user = snapshot.data[index];
                return ListTile(
                  title: Text('${user.name}'),
                  subtitle: Text('${user.email}'),
                );
              },
            ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }
}
