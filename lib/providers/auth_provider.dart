import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/api_config.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  bool _isLoading = false;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  bool get isLoading => _isLoading;

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    _isLoading = true;
    notifyListeners();
    
    final url = Uri.parse(urlSegment);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw Exception(responseData['error']['message']);
      }
      
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, ApiConfig.signUpUrl);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, ApiConfig.signInUrl);
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }
}
