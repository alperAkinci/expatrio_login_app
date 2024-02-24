import 'package:expatrio_login_app/shared/countries_constants.dart';

class ItemDropDown {
  const ItemDropDown(this.key, this.value, this.text);
  final String key;
  final String value;
  final String text;

  factory ItemDropDown.fromJson(Map<String, dynamic> json) {
    return ItemDropDown(
      json["code"],
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
          key == other.key &&
          value == other.value &&
          text == other.text;

  @override
  int get hashCode => key.hashCode ^ value.hashCode ^ text.hashCode;

  @override
  String toString() => text;
}
