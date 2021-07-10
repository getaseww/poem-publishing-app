import 'dart:convert';
//mport 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:p/getdata.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'utils/constants.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post('$API_URL/register', body: {
      'name': name,
      'email': email,
      'password': password,
      'device_name': await getDeviceId(),
    }, headers: {
      'Accept': 'application/json',
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      String token = response.body;
      await saveToken(token);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }

    if (response.statusCode == 422) {
      return false;
    }

    return false;
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post('$API_URL/login', body: {
      'email': email,
      'password': password,
      'device_name': await getDeviceId(),
    }, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      String token = response.body;
      await saveToken(token);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }

    if (response.statusCode == 422) {
      return false;
    }

    return false;
  }

  Future<bool> createPost(String title, String content) async {
    // String token = await getToken();
    final response = await http.post('$API_URL/post/store', body: {
      'title': title,
      'content': content,
    }, headers: {
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $token',
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        return build.androidId;
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        return data.identifierForVendor;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  logout() async {
    _isAuthenticated = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
