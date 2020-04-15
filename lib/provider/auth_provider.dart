import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exption.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _auth(String email, String password, String urlId) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlId?key=AIzaSyAPOANBxtPXgtoOujVQNjjyXf1RXzjgrf4';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      logOutAuto();
      notifyListeners();
      //اللي جاي ده عشان نخلي التسجيل الدخول اوتوماتيك
      final perfs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate.toIso8601String()
      });
      perfs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _auth(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _auth(email, password, 'signInWithPassword');
  }

  Future<bool> tryToLogIn() async {
    final perfs = await SharedPreferences.getInstance();
    if (!perfs.containsKey('userData')) {
      print('no');
      return false;
    }
    print('yes');
    final extractUserData =
        json.decode(perfs.getString('userData')) as Map<String, Object>;
    final expireyDate = DateTime.parse(extractUserData['expireDate']);
    if (expireyDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractUserData['token'];
    _userId = extractUserData['userId'];
    _expireDate = expireyDate;
    logOutAuto();
    notifyListeners();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final perfs = await SharedPreferences.getInstance();
    //remove shared
    perfs.clear();
  }

  void logOutAuto() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    final expiryDate = _expireDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: expiryDate), logOut);
  }
}
