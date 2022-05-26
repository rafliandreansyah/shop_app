import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _API_KEY = 'AIzaSyDOt1-qDTdlhdKGnr6h9xTi3D4B-_j1Z08';
  String? _token;
  String? _userId;
  DateTime? _expiredDate;
  Timer? _timer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiredDate != null &&
        _expiredDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userID {
    return _userId;
  }

  Future<void> _authentication(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$_API_KEY');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        final responseErrorMessage = responseData['error']['message'];
        throw HttpException(responseErrorMessage);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiredDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();

      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiredDate?.toIso8601String(),
      });

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);
      print('useData: $userData');
    } catch (onError) {
      throw onError;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authentication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authentication(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    print('userdata tryAutoLogin: ${prefs.getString('userData')!}');

    final userData =
        json.decode(prefs.getString('userData')!) as Map<String, Object>;

    final expiryDate = DateTime.parse(userData['expiryDate'] as String);
    final token = userData['token'] as String;
    final userId = userData['userId'] as String;

    print('expired: ${expiryDate}');
    print('token: $token');
    print('user id: $userId');

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _expiredDate = expiryDate;
    _token = token;
    _userId = userId;

    notifyListeners();
    _autoLogout();

    return true;
  }

  void logout() {
    _userId = null;
    _token = null;
    _expiredDate = null;
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    print('userid: $_userId\ntoken: $_token\nexpiredDate: $_expiredDate');

    notifyListeners();
  }

  void _autoLogout() {
    if (_timer != null) {
      _timer?.cancel();
    }
    var timerLogout = _expiredDate?.difference(DateTime.now()).inSeconds;
    print('timer: ${timerLogout}');
    _timer = Timer(Duration(seconds: timerLogout ?? 0), logout);
  }
}
