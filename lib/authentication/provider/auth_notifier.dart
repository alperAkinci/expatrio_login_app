import 'dart:convert';
import 'dart:io';
import 'package:expatrio_login_app/authentication/model/auth.dart';
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
      Map<String, String> headers = {
        "Content-type": "application/json",
      };

      final response =
          await http.post(url, headers: headers, body: jsonEncode(data));
      final responseData = Auth.fromJson(response.body);

      if (response.statusCode == HttpStatus.ok &&
          responseData.token != null &&
          responseData.userId != null) {
        _token = responseData.token!;
        _saveToken(token, responseData.userId!);
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

  void _saveToken(String token, int userId) async {
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'userId', value: userId.toString());
  }

  void _deleteToken() async {
    _isAuthenticated = false;
    await storage.delete(key: 'token');
    await storage.delete(key: 'userId');
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
