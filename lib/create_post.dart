import 'package:flutter/material.dart';
import 'package:p/login.dart';
import 'package:provider/provider.dart';
import './auth.dart';
import 'drawer.dart';

class PostForm extends StatefulWidget {
  const PostForm({
    Key key,
  }) : super(key: key);

  @override
  PostFormState createState() => PostFormState();
}

class PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _content;
  String _errorMessage = '';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> submitForm() async {
    setState(() {
      _errorMessage = '';
    });
    bool result = await Provider.of<AuthProvider>(context, listen: false)
        .createPost(_title, _content);
    if (result == false) {
      setState(() {
        _errorMessage = 'There was a problem.';
      });
    } else {
      setState(() {
        _onWillPop();
      });
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text("You are successfully registered. Login now?"),
            title: Text(
              "Success Message",
              style: TextStyle(color: Colors.green),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => LoginForm()));
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Text(
              "Post your poem",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Title'),
                  TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Title of your poem',
                      labelText: 'Title of your poem',
                    ),
                    validator: (value) =>
                        value.isEmpty ? 'Please enter title of the poem' : null,
                    onSaved: (value) => _title = value,
                    maxLines: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10, 0.0, 0.0),
                  ),
                  Text('Content'),
                  TextFormField(
                    style: TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Content of your poem",
                      labelText: "Content of your poem",
                    ),
                    validator: (value) => value.isEmpty
                        ? 'Please enter content of the poem'
                        : null,
                    onSaved: (value) => _content = value,
                    maxLines: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                    child: RaisedButton(
                      elevation: 3.0,
                      child: Text('save'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          submitForm();
                        }
                      },
                    ),
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
