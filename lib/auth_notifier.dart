import 'dart:convert';
import 'dart:io';
import 'package:expatrio_login_app/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthNotifier extends ChangeNotifier {
  final storage = const FlutterSecureStorage();

  bool _isAuthenticated = false;
  String _token = '';

  bool get isAuthenticated => _isAuthenticated;
  String get token => _token;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void init({String? token}) {
    if (token != null && token.isNotEmpty) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<Auth> signIn({
    required Map data,
    Function? onSuccess,
    Function? onError,
  }) async {
    setLoading(true);
    try {
      final url = Uri.parse('https://dev-api.expatrio.com/auth/login');
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));
      final responseData = Auth.fromJson(response.body);

      if (response.statusCode == HttpStatus.ok && responseData.token != null) {
        _token = responseData.token!;
        _saveToken(token);
        _isAuthenticated = true;
        notifyListeners();

        onSuccess?.call();
        return responseData;
      } else {
        throw Exception(responseData.message ?? 'An error occurred');
      }
    } catch (error) {
      onError?.call(error.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    _deleteToken();
    notifyListeners();
  }

  void _saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  void _deleteToken() async {
    _isAuthenticated = false;
    await storage.delete(key: 'token');
  }

  Future<void> checkToken() async {
    try {
      await storage.read(key: 'token').then((token) {
        if (token != null && token.isNotEmpty) {
          _isAuthenticated = true;
          _token = token;
          notifyListeners();
        } else {
          _isAuthenticated = false;
          _token = '';
          notifyListeners();
        }
      });
    } catch (error) {
      rethrow;
    }
  }
}
