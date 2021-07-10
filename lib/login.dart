import 'package:flutter/material.dart';
import 'package:p/register.dart';
import 'package:provider/provider.dart';
import './auth.dart';
import 'drawer.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,
  }) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage = '';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> submitForm() async {
    setState(() {
      _errorMessage = '';
    });
    bool result = await Provider.of<AuthProvider>(context, listen: false)
        .login(_email, _password);
    if (result == false) {
      setState(() {
        _errorMessage = 'There was a problem with your credentials.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.5, 0.9],
          colors: [
            Colors.red,
            Colors.orange,
          ],
        )),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (value) => value.isEmpty
                                    ? 'Please enter an email address'
                                    : null,
                                onSaved: (value) => _email = value,
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (value) => value.isEmpty
                                    ? 'Please enter a password'
                                    : null,
                                onSaved: (value) => _password = value,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 16.0, 0.0, 0.0),
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 8.0, 0.0, 0.0),
                                child: RaisedButton(
                                  elevation: 5.0,
                                  child: Text('Login'),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => RegisterForm()));
                        },
                        child: Text(
                          'Do not  have an account? Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
