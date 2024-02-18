class ItemDropDown {
  const ItemDropDown(this.key,this.value,this.text);
  final String key;
  final String value;
  final String text;


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
  String toString() {
    return 'ItemDropDown{key: $key, value: $value, text: $text}';
  }
}