import 'dart:io';
import 'package:expatrio_login_app/tax_data/model/tax_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TaxDataNotifier extends ChangeNotifier {
  late TaxData _taxData;
  TaxData get taxData => _taxData;
  final _storage = const FlutterSecureStorage();
  final String _baseURL = "https://dev-api.expatrio.com";

  Future<TaxData> getTaxData() async {
    final token = await _storage.read(key: 'token');
    final userId = int.parse(await _storage.read(key: 'userId') ?? "");
    final url = Uri.parse('$_baseURL/v3/customers/$userId/tax-data');
    final response = await http.get(url, headers: {
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == HttpStatus.ok) {
      final responseData = TaxData.fromJson(response.body);
      _taxData = responseData;
      notifyListeners();
      return responseData;
    } else {
      throw Exception('Failed to load tax data!');
    }
  }

  Future<TaxData> updateTaxData(TaxResidence primaryTaxResidence,
      List<TaxResidence> secondaryTaxResidence) async {
    final token = await _storage.read(key: 'token');
    final userId = int.parse(await _storage.read(key: 'userId') ?? "");
    final url = Uri.parse('$_baseURL/v3/customers/$userId/tax-data');

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token",
    };

    var data = TaxData(
        primaryTaxResidence: primaryTaxResidence,
        secondaryTaxResidence: secondaryTaxResidence,
        usPerson: false,
        usTaxId: null,
        w9FileId: null);

    final response = await http.put(url, headers: headers, body: data.toJson());

    if (response.statusCode == HttpStatus.ok) {
      _taxData = data;
      notifyListeners();
      return data;
    } else {
      throw Exception('Failed to update tax data!');
    }
  }
}
