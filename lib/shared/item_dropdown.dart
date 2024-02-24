import 'package:expatrio_login_app/shared/countries_constants.dart';

class ItemDropDown {
  ItemDropDown(this.code, this.label);
  String code;
  String label;

  factory ItemDropDown.fromJson(Map<String, dynamic> json) {
    return ItemDropDown(
      json["code"],
      json["label"],
    );
  }

  static List<ItemDropDown> fromJsonList(List list) {
    return list.map((item) => ItemDropDown.fromJson(item)).toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemDropDown &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          label == other.label;

  @override
  int get hashCode => code.hashCode ^ label.hashCode;

  @override
  String toString() => label;
}
