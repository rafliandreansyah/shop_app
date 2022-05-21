import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _API_KEY = 'AIzaSyDOt1-qDTdlhdKGnr6h9xTi3D4B-_j1Z08';
  String? _token;
  String? _userId;
  DateTime? _expiredDate;

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
      notifyListeners();
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
}
