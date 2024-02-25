import 'dart:convert' show json;
import 'dart:ffi';

class TaxData {
  TaxData({
    required this.primaryTaxResidence,
    required this.secondaryTaxResidence,
    required this.usPerson,
    required this.usTaxId,
    required this.w9FileId,
  });
  late final TaxResidence primaryTaxResidence;
  late final List<TaxResidence> secondaryTaxResidence;
  late final bool usPerson;
  late final String? usTaxId;
  late final int? w9FileId;

  factory TaxData.fromJson(String data) {
    return TaxData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  TaxData.fromMap(Map<String, dynamic> json) {
    primaryTaxResidence = TaxResidence.fromJson(json['primaryTaxResidence']);
    secondaryTaxResidence = List<TaxResidence>.from(
        json['secondaryTaxResidence'].map((x) => TaxResidence.fromJson(x)));
    usPerson = json['usPerson'];
    usTaxId = json['usTaxId'];
    w9FileId = json['w9FileId'];
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['primaryTaxResidence'] = primaryTaxResidence.toJson();
    data['secondaryTaxResidence'] =
        secondaryTaxResidence.map((x) => x.toJson()).toList();
    data['usPerson'] = usPerson;
    data['usTaxId'] = usTaxId;
    data['w9FileId'] = w9FileId;
    return data;
  }
}

class TaxResidence {
  TaxResidence({
    required this.country,
    required this.id,
  });

  late final String country;
  late final String id;

  TaxResidence.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['country'] = country;
    data['id'] = id;
    return data;
  }
}
